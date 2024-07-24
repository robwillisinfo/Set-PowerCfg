<#
.SYNOPSIS

This simple script can be used to easily set or check the current power scheme being 
applied.

.DESCRIPTION

Set-PowerCfg is a simple script that can be used to easily set or check the current 
power scheme being applied on a Windows host, these are the same settings found in 
Control Panel > Power Options.

This is particularly useful on laptops where CPU throttling may be an issue and you 
need to easily switch between power profiles, ie plugged in vs running on battery. 

Author: Rob Willis (admin@robwillis.info / @b1t_r0t)

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

# Set PowerCfg- Options 1-4
Function setPowerCfg {
	Write-Host "Checking to see if the requested power scheme exists..."
	$availableSchemes = Powercfg /l
	# Check to see if the scheme exists, add it if it does not
	if ($availableSchemes -match $scheme) {
		Write-Host "Scheme found" -ForegroundColor Green
	} else {
		Write-Host "Scheme not found`n" -ForegroundColor Red
		Write-Host "Adding scheme..."
			Powercfg /duplicatescheme $scheme
			# If unable to add scheme, do not attempt to apply, go back to menu
			if ($lastexitcode -eq 1) {
				Write-Host ""
				Pause
				Menu
			}
	}
	Write-Host "`n"
	Write-Host "Applying scheme..."
	Powercfg /SETACTIVE $scheme
	$currentScheme = Powercfg /getactivescheme
	Write-Host "Applied Power Scheme:" $currentScheme
	Write-Host ""
	Pause
	Menu
}

# Show current settings- Option 0
Function currentPowerCfg {
	$currentScheme = Powercfg /getactivescheme
	Write-Host "Current Power Scheme:`n" $currentScheme
	Write-Host ""
	Pause
	Menu
}

Function deletePowerCfg {
	Write-Host "Gathering available schemes..."
	Powercfg /l
	Write-Host ""
	$guid = Read-Host "Enter the GUID of the power scheme to be deleted or q to return to the menu"
	if ($guid -eq "q") {
		Menu
	} else {
		PowerCfg /delete $guid
		Write-Host ""
	}
	Pause
	Menu
}

Function listPowerCfg {
	Write-Host "Gathering available schemes..."
	Powercfg /l
	Write-Host ""
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

	# User input fro selection
	Write-Host "+---------------------------------------------------------------------"
	Write-Host "| Set-PowerCfg v1.1 - RobWillis.info"
	Write-Host "+---------------------------------------------------------------------`n"
	Write-Host "+---------------------------------------------------------------------"
	Write-Host "| Power Configuration Schemes"
	Write-Host "+---------------------------------------------------------------------"
	Write-Host "  1 = Power saver"
	Write-Host "  2 = Balanced"
	Write-Host "  3 = High performance"
	Write-Host "  4 = Ultra performance`n"
	Write-Host "+---------------------------------------------------------------------"
	Write-Host "| Maintenance"
	Write-Host "+---------------------------------------------------------------------"
	Write-Host "  S = Show current power scheme"	
	Write-Host "  L = List available power schemes"	
	Write-Host "  D = Delete a power scheme"	
	Write-Host "  Q = Quit`n"
	
	$input = Read-Host -Prompt "Selection"
	Write-Host ""
	if("$input" -like "1"){ $scheme = "a1841308-3541-4fab-bc81-f71556f20b4a"; setPowerCfg }
	if("$input" -like "2"){ $scheme = "381b4222-f694-41f0-9685-ff5bb260df2e"; setPowerCfg }
	if("$input" -like "3"){ $scheme = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"; setPowerCfg }
	if("$input" -like "4"){ $scheme = "1cbf7808-13a4-48a1-8eaa-3eb186b1adf9"; setPowerCfg }
	if("$input" -like "S"){ currentPowerCfg }
	if("$input" -like "L"){ listPowerCfg }
	if("$input" -like "D"){ deletePowerCfg }
	if("$input" -like "Q"){ quit }
	else {	
	Menu
	}
}

# Begin execution - Run the menu
Menu
