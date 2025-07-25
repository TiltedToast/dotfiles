using namespace System.Management.Automation
using namespace System.Management.Automation.Language

oh-my-posh init pwsh --config "C:\Users\tim\powerline_custom.omp.json" | Invoke-Expression

$env:PATH = "$env:PATH2;$env:PATH"

if (Get-Alias gc -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:gc -Force
    # Remove-Alias gc -Force
}
if (Get-Alias gp -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:gp -Force
    # Remove-Alias gp -Force
}
if (Get-Alias cat -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:cat -Force
    # Remove-Alias cat -Force
}
if (Get-Alias ls -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:ls -Force
    # Remove-Alias ls -Force
}
if (Get-Alias where -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:where -Force
    # Remove-Alias where -Force
}
if (Get-Alias kill -ErrorAction SilentlyContinue) {
    Remove-Item -Path Alias:kill -Force
    # Remove-Alias where -Force
}

# Windows Powershell do be too old sadge
# Import-WslCommand "awk", "grep", "head", "less", "seq", "tail", "parallel", "jq", "find", "apt", "exa", "time"

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-Alias gst gitstatus
Set-Alias c clear
Set-Alias gc git_commit
Set-Alias l eza_pretty
Set-Alias ls eza
Set-Alias gcam git_add_commit
Set-Alias s source_profile
Set-Alias gp git_push
Set-Alias rgi rg_case_insensitive
Set-Alias wiki wiki_tui_search
Set-Alias drs danbooru-rs
Set-Alias dgo danbooru-go
Set-Alias gpl git_pull
Set-Alias cnew cargo_new
Set-Alias cnewtokio cargo_new_tokio
Set-Alias cat bat_with_theme
Set-Alias gco git_checkout
Set-Alias gsta git_stash
Set-Alias cb cargo_build_debug
Set-Alias cbr cargo_build_release
Set-Alias cr cargo_run_debug
Set-Alias crr cargo_run_release
Set-Alias cip cargo_install_local
Set-Alias ci cargo_install
Set-Alias where where_alias
Set-Alias volat volta
Set-Alias cm chezmoi
Set-Alias touch create_new_file
Set-Alias pn pnpm
Set-Alias gam git_amend
Set-Alias vim nvim
Set-Alias e explorer.exe
Set-Alias ldd ldd_
Set-Alias rip trash_things
Set-Alias kill task_kill
Set-Alias time Measure_Command
Set-Alias invert invert_pdf
Set-Alias rmrf set_rmrf

function invert_pdf {
    $file = Get-Item -Path $args[0]
    $invertedFile = $file.FullName + ".inverted.pdf"

    # Start the gswin64 process
    gswin64 -o $invertedFile -sDEVICE=pdfwrite -c "{1 exch sub}{1 exch sub}{1 exch sub}{1 exch sub} setcolortransfer" -f $file.FullName | Out-Null

    Remove-Item -Force -Path $file.FullName
    Rename-Item -Path $invertedFile -NewName $file.Name
}

function code_r { code -r $args }

function Measure_Command {
    $command = $args -join ' '

    $scriptBlock = [scriptblock]::Create($Command -join ' ')

    if ($scriptBlock.ToString().Length -eq 0) {
        Write-Error "No command specified"
        return
    }

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        Invoke-Command -ScriptBlock $scriptBlock -ErrorVariable err
    }
    catch {
        Write-Error $_.Exception.Message
    }

    $stopwatch.Stop()

    if ($err) { $err | ForEach-Object { Write-Error $_.ToString() } }

    $elapsed = $stopwatch.Elapsed
    $formattedElapsedTime = New-Object PSObject -Property ([ordered]@{
            TotalMinutes      = [math]::Round($elapsed.TotalMinutes, 2)
            TotalSeconds      = [math]::Round($elapsed.TotalSeconds, 2)
            TotalMilliseconds = [math]::Round($elapsed.TotalMilliseconds, 2)
        })

    $formattedElapsedTime | Format-List
}

function task_kill {
    $imArgs = $args | ForEach-Object { "/IM $_" }
    $imArgsString = $imArgs -join ' '
    sudo taskkill.exe /F $imArgsString
}

function Remove-Item-ToRecycleBin($Path) {
    $item = Get-Item -Path $Path -ErrorAction SilentlyContinue
    if ($null -eq $item) {
        Write-Error("'{0}' not found" -f $Path)
    }
    else {
        $fullPath = $item.FullName
        Write-Output("Moving '{0}' to the Recycle Bin" -f $fullPath)
        if (Test-Path -Path $fullPath -PathType Container) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($fullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
        }
        elseif (Test-Path -Path $fullPath -PathType Leaf) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($fullpath, 'OnlyErrorDialogs', 'SendToRecycleBin')
        }
        else {
            Write-Error("'{0}' is neither a directory, nor a file" -f $fullPath)
        }
    }
}
function ldd_ { dumpbin.exe /DEPENDENTS $args }
function git-amend { git add . ; git commit --amend --no-edit }
function create-new-file { echo $null >> $args }
function where-alias { where.exe $args }
function cargo-install { cargo install $args }
function cargo-install-local { cargo install --path . $args }
function cargo-run-debug { cargo run $args }
function cargo-run-release { cargo run --release $args }
function cargo-build-debug { cargo build $args }
function cargo-build-release { cargo build --release $args }
function git-stash { git stash $args }
function git-checkout { git checkout $args }
function gitstatus { git status $args }
function git-commit { git commit $args }
function git-add-commit { git add . ; git commit -m $args }
function git-push { git push $args }
function source-profile {
    cmd.exe /c start pwsh.exe -c { Set-Location $PWD } -NoExit
    Stop-Process -Id $PID
}
function set-rmrf { foreach ($arg in $args) { Remove-Item $arg -Recurse -Force } }
function rg-case-insensitive {
    if ($MyInvocation.ExpectingInput) {
        $input | rg --ignore-case $args
    }
    else {
        rg --ignore-case $args
    }
}
function wiki-tui-search { wiki-tui $args }
function git-pull { git pull $args }
function cargo-new-tokio {
    cargo new --bin $args
    Set-Location $args[0]
    cargo add tokio --features="full"
    cargo add anyhow
    code .
}
function cargo-new {
    cargo new --bin $args
    Set-Location $args[0]
    cargo add anyhow
    code .
}

function bat-with-theme {
    bat --theme "One Dark" $args
}

function run-npm-or-pnpm {
    if (Test-Path -Path "pnpm-lock.yaml") {
        pnpm $args
    }
    else {
        c:\PROGRA~1/nodejs/npm.cmd $args
    }
}

function lsd-pretty { lsd --config-file "C:\Users\tim\AppData\Roaming\lsd\config.yaml" -lah $args }
function eza_pretty {
    eza -laah --colour=always --icons=always --group-directories-first -s name --time-style "+%d %b %y %X" $args
}



Register-ArgumentCompleter -Native -CommandName 'volta' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'volta'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'volta' {
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Prints the current version of Volta')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints the current version of Volta')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterValue, 'Fetches a tool to the local machine')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Installs a tool in your toolchain')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstalls a tool from your toolchain')
                [CompletionResult]::new('pin', 'pin', [CompletionResultType]::ParameterValue, 'Pins your project''s runtime or package manager')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'Displays the current toolchain')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generates Volta completions')
                [CompletionResult]::new('which', 'which', [CompletionResultType]::ParameterValue, 'Locates the actual binary that will be called by Volta')
                [CompletionResult]::new('use', 'use', [CompletionResultType]::ParameterValue, 'use')
                [CompletionResult]::new('setup', 'setup', [CompletionResultType]::ParameterValue, 'Enables Volta for the current user / shell')
                [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a command with custom Node, npm, pnpm, and/or Yarn versions')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
                break
            }
            'volta;fetch' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;install' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;uninstall' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;pin' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;list' {
                [CompletionResult]::new('--format', 'format', [CompletionResultType]::ParameterName, 'Specify the output format')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Show the currently-active tool(s)')
                [CompletionResult]::new('--current', 'current', [CompletionResultType]::ParameterName, 'Show the currently-active tool(s)')
                [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Show your default tool(s).')
                [CompletionResult]::new('--default', 'default', [CompletionResultType]::ParameterName, 'Show your default tool(s).')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;completions' {
                [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'File to write generated completions to')
                [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'File to write generated completions to')
                [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Write over an existing file, if any.')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Write over an existing file, if any.')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;which' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;use' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;setup' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;run' {
                [CompletionResult]::new('--node', 'node', [CompletionResultType]::ParameterName, 'Set the custom Node version')
                [CompletionResult]::new('--npm', 'npm', [CompletionResultType]::ParameterName, 'Set the custom npm version')
                [CompletionResult]::new('--pnpm', 'pnpm', [CompletionResultType]::ParameterName, 'Set the custon pnpm version')
                [CompletionResult]::new('--yarn', 'yarn', [CompletionResultType]::ParameterName, 'Set the custom Yarn version')
                [CompletionResult]::new('--env', 'env', [CompletionResultType]::ParameterName, 'Set an environment variable (can be used multiple times)')
                [CompletionResult]::new('--bundled-npm', 'bundled-npm', [CompletionResultType]::ParameterName, 'Forces npm to be the version bundled with Node')
                [CompletionResult]::new('--no-pnpm', 'no-pnpm', [CompletionResultType]::ParameterName, 'Disables pnpm')
                [CompletionResult]::new('--no-yarn', 'no-yarn', [CompletionResultType]::ParameterName, 'Disables Yarn')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
            'volta;help' {
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
    Sort-Object -Property ListItemText
}
# powershell completion for chezmoi                              -*- shell-script -*-

function __chezmoi_debug {
    if ($env:BASH_COMP_DEBUG_FILE) {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __chezmoi_escapeStringWithSpecialChars {
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&', '`$&'
}

[scriptblock]$__chezmoiCompleterBlock = {
    param(
        $WordToComplete,
        $CommandAst,
        $CursorPosition
    )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __chezmoi_debug ""
    __chezmoi_debug "========= starting completion logic =========="
    __chezmoi_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition) {
        $Command = $Command.Substring(0, $CursorPosition)
    }
    __chezmoi_debug "Truncated command: $Command"

    $ShellCompDirectiveError = 1
    $ShellCompDirectiveNoSpace = 2
    $ShellCompDirectiveNoFileComp = 4
    $ShellCompDirectiveFilterFileExt = 8
    $ShellCompDirectiveFilterDirs = 16
    $ShellCompDirectiveKeepOrder = 32

    # Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program, $Arguments = $Command.Split(" ", 2)

    $RequestComp = "$Program __completeNoDesc $Arguments"
    __chezmoi_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" ) {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __chezmoi_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag ) {
        __chezmoi_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag, $WordToComplete = $WordToComplete.Split("=", 2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag )) {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __chezmoi_debug "Adding extra empty parameter"
        # PowerShell 7.2+ changed the way how the arguments are passed to executables,
        # so for pre-7.2 or when Legacy argument passing is enabled we need to use
        # `"`" to pass an empty argument, a "" or '' does not work!!!
        if ($PSVersionTable.PsVersion -lt [version]'7.2.0' -or
            ($PSVersionTable.PsVersion -lt [version]'7.3.0' -and -not [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -or
            (($PSVersionTable.PsVersion -ge [version]'7.3.0' -or [ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) -and
            $PSNativeCommandArgumentPassing -eq 'Legacy')) {
            $RequestComp = "$RequestComp" + ' `"`"'
        }
        else {
            $RequestComp = "$RequestComp" + ' ""'
        }
    }

    __chezmoi_debug "Calling $RequestComp"
    # First disable ActiveHelp which is not supported for Powershell
    $env:CHEZMOI_ACTIVE_HELP = 0

    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null

    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "") {
        # There is no directive specified
        $Directive = 0
    }
    __chezmoi_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __chezmoi_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 ) {
        # Error code.  No completion.
        __chezmoi_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    [Array]$Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t", 2)
        __chezmoi_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length) {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description) {
            $Description = " "
        }
        @{Name = "$Name"; Description = "$Description" }
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 ) {
        # remove the space here
        __chezmoi_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 )) {
        __chezmoi_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag ) {
            __chezmoi_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    # we sort the values in ascending order by name if keep order isn't passed
    if (($Directive -band $ShellCompDirectiveKeepOrder) -eq 0 ) {
        $Values = $Values | Sort-Object -Property Name
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 ) {
        __chezmoi_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0) {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object { $_.Key -eq "Tab" }).Function
    __chezmoi_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode) {

            # bash like
            "Complete" {

                if ($Values.Length -eq 1) {
                    __chezmoi_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __chezmoi_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                }
                else {
                    # Add the proper number of spaces to align the descriptions
                    while ($comp.Name.Length -lt $Longest) {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " ) {
                        $Description = ""
                    }
                    else {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
            }

            # zsh like
            "MenuComplete" {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __chezmoi_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because that's not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __chezmoi_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

Register-ArgumentCompleter -CommandName 'chezmoi' -ScriptBlock $__chezmoiCompleterBlock
Register-ArgumentCompleter -CommandName 'cm' -ScriptBlock $__chezmoiCompleterBlock
Invoke-Expression (&sfsu hook)

$hifumi = "E:\coding-projects\hifumi-js"
$violet = "E:\coding-projects\violet"
$miku = "E:\coding-projects\miku"
$uni = "E:\coding-projects\uni"
$code = "E:\coding-projects"
$scala = "E:\coding-projects\scala"
$rust = "E:\coding-projects\rust"
$notes = "G:\My Drive\Notes"
Import-Module gsudoModule

Import-Module 'C:\vcpkg\scripts\posh-vcpkg'
Import-Module 'gsudoModule'
$env:PATH = "$env:APPDATA\Python\Scripts;$env:PATH"

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
