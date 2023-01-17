# Lean 4 Autograder

This project provides a Lean 4 autograder that works with [Gradescope](https://gradescope-autograders.readthedocs.io/en/latest/).

To generate the files Gradescope needs, this project uses a repository on GitHub that must contain a template of the assignment the students will receive. This project retrieves from the template, how many points each exercise is worth. Thus, the solution must follow the following pattern:

```lean
/- 2 points -/
theorem th3 (h : ¬q → ¬p) : (p → q) := sorry
```

To interact with GitHub, this project uses GitHub API. Follows the steps needed for connecting to the API:

1. Create a GitHub personal access token following the steps listed [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-personal-access-token-classic). Please select the **repo** scope.

2. In PythonScripts/config.json replace the following variables values:
    - **api_key** with the key generated in step 1.
    - **private_repo** with the repo path you that contains your files.
    - **public_repo** with the name you wish to give to the public repo.
    - **assignment_path** with the path for the assignment available in the **public** repo.

### Helper Scripts

We provide a set of scripts that can help to maintain/create the autograder and repos. For using the python scripts, first install the requirements: `pip install -r requirements.txt`

1. **PythonScripts/configure_public_repo.py** creates the public repo with templates for the students from a private repo containing solutions.

2. **PythonScripts/get_template_from_github.py** retrieves the assignment template from GitHub and generates helper files that will be used by the autograder. This is meant to be used by the autograder on Gradescope.

3. **make_autograder.sh** generates the zip file to be uploaded to Gradescope.

### Gradescope Container Minimum Specifications

This project is meant to work with MathLib assignments, so for a good Gradescope performance, their container must have at least 2.0 CPU and 3.0GB RAM.
