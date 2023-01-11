# Lean 4 Autograder

This project provides a Lean 4 autograder that works with [Gradescope](https://gradescope-autograders.readthedocs.io/en/latest/).

To generate the files Gradescope needs, this project uses a repository on GitHub (which can be private) that must contain a solution for the assignment the students will receive. This project also retrieves from the solution, how many points each exercise is worth. Thus, the solution must follow the following pattern:

```lean
/- 2 points -/
theorem th3 (h : ¬q → ¬p) : (p → q) := 
    fun hp => Or.elim (em q)
        (fun hq => hq)
        (fun hnq => False.elim ((h hnq) hp))
```

This project also removes the body of the theorems in the solution, and publishes them to a new GitHub repo to work as a template for the students.

Additionally, to interact with GitHub, this project uses GitHub API. Follows the steps needed:

1. Create a GitHub personal access token following the steps listed [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-personal-access-token-classic). Please select the **repo** scope.

2. In setup_files.py replace the following variables values:
    - **GIT_HUB_API_KEY** with the key generated in step 1.
    - **PRIVATE_REPO_NAME** with the repo path you wish to clone.
    - **PUBLIC_REPO_NAME** with the name you wish to give to the public repo.
    - **ASSIGNMENT_FILE_PATH** with the path for the assignment available in the private repo.

3. `bash make_autograder.sh`

After running the make_autograder script, you should have the autograder.zip file to be uploaded to Gradescope, and the template repo should be available on GitHub.