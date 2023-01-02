# lean4_autograder

This project uses Github API for interacting with GitHub. 
So, there are a few steps needed for that.

1. Create a GitHub personal access token following the steps listed [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-personal-access-token-classic). Please select the **repo** scope.

2. In setup_files.py replace the following variables values:
    - **GIT_HUB_API_KEY** with the key generated in step 1.
    - **PRIVATE_REPO_NAME** with the repo path you wish to clone.
    - **PUBLIC_REPO_NAME** with the name you wish to give to the public repo.
    - **ASSIGNMENT_FILE_PATH** with the path for the assignment available in the private repo.

3. `bash make_autograder.sh`

After running the make_autograder script, you should have the autograder.zip file to be uploaded to Gradescope and the public repo should be available on GitHub.