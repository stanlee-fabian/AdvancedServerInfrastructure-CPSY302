# Import active directory module for running AD cmdlets - shouldn't need this in 2016, but...
Import-Module activedirectory

#Be patient while script is running, it takes a few minutes to complete putting users into groups etc.

#=========

#Put users.csv and this script into documents folder and run it. It is important user.xls and script is in same folder.
#=========

  
<#Store the data from csv in the $ADUsers variable - #> 
$adusers=Import-Csv .\users.csv

# First lets check the OU and groups, create them if required... create one to hold users for location
<#$ADUsers|Select-Object|Sort-Object $_.city -Unique|Select-Object $_.city  |ForEach-Object {
    New-ADOrganizationalUnit $_.city
}#>

<#i took out the check for OU's, and since there is a limited number, simply built the OU's I wanted 
- allowed for easy deletion as well in case there's a problem-
put a sub-OU in Calgary to hold the groups and needed path based on various student domain names#>
New-ADOrganizationalUnit Calgary -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit _groups -ProtectedFromAccidentalDeletion $false -Path ('OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADOrganizationalUnit computers -ProtectedFromAccidentalDeletion $false -Path ('OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))


#Depending on how you want to build groups - could be by postion or department - this is clunky but okay in this limited situation
#we know how many OU's and groups we have and it's a limited number.

<#$ADUsers|Select-Object|Sort-Object 'position' -Unique|Select-Object 'position'|ForEach-Object {
    New-ADGroup $_.'position' -groupscope Global
}#>
New-ADGroup Management -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADGroup Accounting -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADGroup VPNUsers -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADGroup WebUsers -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADGroup IT -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))
New-ADGroup Sales -GroupScope Global -path ('OU=_groups,OU=Calgary,'+(get-addomain | select -ExpandProperty distinguishedname))



#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
   

	#Check to see if the user already exists in AD
 <#	if (Get-ADUser -property samaccountname -Filter {SamAccountName  | select -ExpandProperty samaccountname -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $_.Username already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        

        I also removed this portion, since on first creation, they should not exist yet, so we don't need to delete them
        Also - I built the OU's with -protectfromaccidentaldeletion at $false - so they are easy to blow away whole OU and re-do.
        #>

        <#there were some duplicate names with a first initial last name naming convention, so I went with first 3 letters
        of first name, last name convention, you can change this as you see fit. There is only a handful of duplicates and 
        could manually create a few users to match your policy, or update policy to match this. 
        edit the $user.'first name'.substring(0,1) from below if you want fewer (or more) chars from first name#>
    


New-ADUser  -name ($user.first+' '+$user.last) `
            -SamAccountName ($user.first.substring(0,1)+$user.last) `
            -UserPrincipalName ($user.first.substring(0,1)+$user.last+'@'+(get-addomain | select -ExpandProperty forest)) `
            -GivenName $user.first `
            -Surname $user.last `
            -Enabled $True `
            -DisplayName ($user.last+' '+$user.first) `
            -OfficePhone $user.phone `
            -Title $user.position `
            -Initials $user.middle `
            -Office $user.city `
            -city $user.city `
            -StreetAddress $user.street `
            -state $user.province `
            -postalcode $user.postal `
            -path ("ou="+$user.city+","+(get-addomain | select -ExpandProperty distinguishedname)) `
            -ChangePasswordAtLogon $false `
            -AccountPassword (convertto-securestring "P@ssw0rd" -AsPlainText -Force)  ` 
      

 <# - may want to manually create home folders in ADUC based on location           -HomeDirectory "\\myserver\$office\$Username" `
 since I don't know the names of student file servers or shares.
 You can highlight all users in an OU, right click and modify the profile tab to create drive S: \\server\share\%username% and it 
 will create them all in one shot#>
    
    #Clunky addition of users into groups
   
   

    if ($user.position -like "sale*")
        {
        Add-ADGroupMember -identity sales -members ($user.first.substring(0,1)+$user.last)
        }
    if ($user.'position' -like "*manager")
        {
        Add-ADGroupMember -identity management -members ($user.first.substring(0,1)+$user.last)
        Add-ADGroupMember -identity VPNUsers -members ($user.first.substring(0,1)+$user.last)
        }
    if ($user.position -like "account*")
        {
        Add-ADGroupMember -identity accounting ($user.first.substring(0,1)+$user.last)
        Add-ADGroupMember -identity WebUsers ($user.first.substring(0,1)+$user.last)
        }
    if ($user.position -like "IT*")
        {
        Add-ADGroupMember IT -members ($user.first.substring(0,1)+$user.last)
        Add-ADGroupMember -Identity "domain admins" -members ($user.first.substring(0,1)+$user.last)
        }

   


        

new-adComputer -Name $User.computername  -Path ('OU=computers,ou='+$user.city+","+(get-addomain | select -ExpandProperty distinguishedname))


}

#Kill stuff
#remove-ADOrganizationalUnit -Identity "OU=Calgary,",(get-addomain | select -ExpandProperty distinguishedname) -recursive




