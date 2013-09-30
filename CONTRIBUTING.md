# How to contribute

So you want to make Speakerinnen Liste better. Great!

Here are the steps to contribute:

## Working on your own branch

1. [Fork](https://help.github.com/articles/fork-a-repo) the main repository.
   This is your own copy of the `speakerinnen_liste` project to work in.
2. Clone your repository to your local machine.
3. `git checkout -b newdesign`  
This creates a new branch, called `newdesign` in our example, in your local
repository.
4. Make your changes.
5. `git commit`
6. `git push origin newdesign:newdesign`  
This pushes your new branch called `newdesign` to your GitHub repository.

## Integrating your working code to master

1. `git fetch origin`
2. `git checkout origin/newdesign`  
Check the code on the branch.
3. `git checkout master`  
Move to `master` branch.
4. `git merge origin/newdesign`  
You merge the `newdesign` branch into to `master` branch.
5. `git commit`
6. `git push`

## Git(Hub) Help

If you have any questions about Git or GitHub, [GitHub
Help](https://help.github.com/) is a great resource!
