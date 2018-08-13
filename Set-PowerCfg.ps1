<#
.SYNOPSIS

This simple script can be used to easily set or check the current power scheme being 
applied.

.DESCRIPTION

This simple script can be used to easily set or check the current power scheme being 
applied, these are the same settings found in Control Panel > Power Options.

This is particularly useful on laptops where CPU throttling may be an issue and there 
is a need to easily switch between power profiles, for example - plugged in vs running on 
battery.

Author: Rob Willis (admin@robwillis.info)

.EXAMPLE

./Set-PowerCfg.ps1

.NOTES

The script is menu driven, just run it and select a menu option.

#>

# Supress errors
# $ErrorActionPreference= 'silentlycontinue'

# Pause
Function Pause {
	Write-Host -NoNewLine "Press any key to continue...`n"
	$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Power saver - Option 1
Function one {
Powercfg -SETACTIVE SCHEME_MAX
$currentScheme = Powercfg -getactivescheme
$currentScheme = $currentScheme.split("()")
Write-Host "Applied Power Scheme:" $currentScheme[1]
Write-Host "`n"
Pause
Menu
}

# Balanced - Option 2
Function two {
Powercfg -SETACTIVE SCHEME_BALANCED
$currentScheme = Powercfg -getactivescheme
$currentScheme = $currentScheme.split("()")
Write-Host "Applied Power Scheme:" $currentScheme[1]
Write-Host "`n"
Pause
Menu
}

# High perf - Option 3
Function three {
Powercfg -SETACTIVE SCHEME_MIN
$currentScheme = Powercfg -getactivescheme
$currentScheme = $currentScheme.split("()")
Write-Host "Applied Power Scheme:" $currentScheme[1]
Write-Host "`n"
Pause
Menu
}

# Show current settings- Option 0
Function zero {
$currentScheme = Powercfg -getactivescheme
$currentScheme = $currentScheme.split("()")
Write-Host "Current Power Scheme:" $currentScheme[1]
Write-Host "`n"
Pause
Menu
}

# Quit
Function quit {
exit
}

# Menu
Function Menu {
	# Clear the screen
	Clear

    # User input for website to scan
	Write-Host " "
	Write-Host "Please select a Power Configuration Scheme.`n"
	Write-Host "1 = Power saver"
	Write-Host "2 = Balanced"
	Write-Host "3 = High performance"
	Write-Host "0 = Show current power scheme"	
	Write-Host "Q = Quit`n"
	
	$input = Read-Host -Prompt "Selection"
	Write-Host "`n"
	if("$input" -like "1"){ one }
	if("$input" -like "2"){ two }
	if("$input" -like "3"){ three }
	if("$input" -like "0"){ zero }
	if("$input" -like "Q"){ quit }
	else {
	Menu
	}
}

Menu
