import re
import collections
import wget
import github as github

GIT_HUB_API_KEY = "YOUR_KEY"
PRIVATE_REPO_NAME = "vanessa-rodrigues/autograder_test_instructor"
PUBLIC_REPO_NAME = "vanessa-rodrigues/lean_assignment"
ASSIGNMENT_FILE_PATH = "ProblemSets/ProblemSet3.lean"
PROJECT_FILES = [".gitignore", "README.md", "lake-manifest.json", "lakefile.lean", "lean-toolchain"]

def create_repo(git, original_repo, new_file):
    user = git.get_user()
    commit_message = "Assignment files"
    try:
        repo = user.create_repo(PUBLIC_REPO_NAME.split('/')[1])
        for name in PROJECT_FILES:
            content = original_repo.get_contents(name)
            repo.create_file(name, commit_message, content.decoded_content.decode("utf-8"))
    
    except github.GithubException:
        print ("Repo already exists, commiting a new file instead")
        repo = git.get_repo(PUBLIC_REPO_NAME)
    
    repo.create_file(ASSIGNMENT_FILE_PATH, commit_message, ''.join(new_file))

def locate_function_signature_and_add_sorry(queue, file):
    while len(queue) > 0:
        line = queue.popleft()
        pos = line.find(':=')
        if pos != -1:
            file.append(line[: pos + 2] + " sorry")
            return
        else: 
            file.append(line)
            file.append('\n')

def remove_theorem_body(queue, file):
    should_ignore = False
    while len(queue) > 0:
        line = queue.popleft()
        if problems.match(line.strip()):
            queue.appendleft(line)
            locate_function_signature_and_add_sorry(queue, file)
            should_ignore = True
            file.append('\n\n')
        elif comments.match(line.strip()) and len(queue) > 0 and problems.match(queue[0]):
            should_ignore = False
        
        if not should_ignore:
            file.append(line)
            file.append('\n')

def extract_points_and_function_names(queue):
    names = {}
    points = 0
    comment = False
    while len(queue) > 0:
        line = queue.popleft().strip()
        if comments.match(line):
            comment = True
            words = line.split(" ")
            points = words[1]
        else:
            if comment and problems.match(line): 
                words = line.split(" ")
                names[words[1]] = int(points)
            comment = False
    return names

def write_exercises_file(names):
    file = open("AutograderTests/exercises.txt", "w", encoding='utf8')
    for name, points in names.items():
        file.write(name + ';' + str(points) + '\n')
    file.close()

def __main__():
    try:
        g = github.Github(GIT_HUB_API_KEY)
        repo = g.get_repo(PRIVATE_REPO_NAME)

        content = repo.get_contents(ASSIGNMENT_FILE_PATH)
        wget.download(content.download_url, out = "AutograderTests/Solution.lean")
        text = content.decoded_content.decode("utf-8").split('\n')

        queue_1 = collections.deque(text)
        queue_2 = collections.deque(text)

        names = extract_points_and_function_names(queue_1)
        write_exercises_file(names)

        new_file_text = []
        remove_theorem_body(queue_2, new_file_text)
        create_repo(g, repo, new_file_text)
    
    except github.GithubException as err:
        print (err)

comment_pattern = "^/-.*-/$"
problem_pattern = "^(theorem|lemma){1}.*"

problems = re.compile(problem_pattern)
comments = re.compile(comment_pattern)

__main__()

