# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS = "Password1"
$NUMBER_OF_ACCOUNTS_TO_CREATE = 1000
# ------------------------------------------------------ #

Function generate-random-name {
    $consonants = @('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z')
    $vowels = @('a','e','i','o','u','y')
    $nameLength = Get-Random -Minimum 3 -Maximum 7
    $count = 0
    $name = ""

    while ($count -lt $nameLength) {
        if ($count % 2 -eq 0) {
            $name += $consonants | Get-Random
        } else {
            $name += $vowels | Get-Random
        }
        $count++
    }
    return $name
}

$count = 1
while ($count -le $NUMBER_OF_ACCOUNTS_TO_CREATE) {

    $firstName = generate-random-name
    $lastName  = generate-random-name

    # Username: first initial + lastname
    $username = ("{0}{1}" -f $firstName.Substring(0,1), $lastName).ToLower()

    $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

    Write-Host "Creating user: $username" -ForegroundColor Cyan

    New-ADUser `
        -SamAccountName $username `
        -UserPrincipalName "$username@mydomain.com" `
        -GivenName $firstName `
        -Surname $lastName `
        -DisplayName "$firstName $lastName" `
        -Name "$firstName $lastName" `
        -EmployeeID $username `
        -AccountPassword $password `
        -PasswordNeverExpires $true `
        -Enabled $true `
        -Path "OU=_USERS,DC=mydomain,DC=com"

    $count++
}
