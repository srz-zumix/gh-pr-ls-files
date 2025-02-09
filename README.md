# gh-pr-ls-files

This extension or action gets a list of added/deleted/modfied files in a pull request without checkout.

## GitHub CLI Extension

### Getting Started

```sh
gh extension install "srz-zumix/gh-pr-ls-files"
```

```sh
gh pr-ls-files -h
```

```text
gh pr-ls-files <pr number|url|branch>
    
list files in the pull request

    -a, --added           show added files in the output
    -d, --deleted         show deleted files in the output
    -m, --modified        show modified files in the output
    -r, --renamed         show renamed files in the output
    -R, --repo            repository name
```

## GitHub Actions Action

### Usage

#### List all files

```yaml
- uses: srz-zumix/gh-pr-ls-files@v1
```

#### List deleted files

```yaml
- uses: srz-zumix/gh-pr-ls-files@v1
  with:
    deleted: true
```

#### List non-deleted (added/modified/renamed) files

```yaml
- uses: srz-zumix/gh-pr-ls-files@v1
  with:
    deleted: false
```

### Inputs

#### `pull_request`

pull request number|url|branch. Default: `${{ github.event.pull_request.html_url }}`

#### `repository`

Repository name with owner. For example, srz-zumix/gh-pr-ls-files. Default: `${{ github.repository }}`

#### `added`

show added files in the output.

#### `deleted`

show deleted files in the output.

#### `modified`

show modified files in the output.

#### `renamed`

show renamed files in the output.

#### `filter`

show files with the specified grep filter in the output.

e.g. `".*(\.ino|\.cpp|\.c|\.h|\.hpp|\.hh)$"`

#### `delimiter`

delimiter for the output.

#### `github_token`

GitHub TOKEN. Default: `github.token`

### Outputs

#### `files`

files in the pull request.

#### `count`

count of files in the pull request.
