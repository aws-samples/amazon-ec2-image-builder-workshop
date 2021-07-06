$build = @(
    (IBS -UpdateOS -name 'update'),
    (IBS -ExecutePowerShell -name 'install-iis' 'Install-WindowsFeature Web-Server -ErrorAction stop'),
    (IBS3A 's3://ee-assets-prod-us-east-1/modules/fdbebd0c9c3c488cbe1c60adcdc48655/v1/unicorn.png' 'C:\inetpub\wwwroot\' |
        IBS -s3dl -name 'dlUnicorn'),
    (Get-Content create-index.ps1 -Raw | IBS -ExecuteBash -name 'create-index'),
    (IBS -Reboot -name 'reboot')
) | IBP 'build' 

$validate = 'if (!(Get-WindowsFeature "web-server").installed) {throw "NOT INSTALLED"} else {"OK: web-server is installed"}' | 
IBS -ExecutePowerShell -name 'validate-iis' | IBP 'validate'

$test = Get-Content test.ps1 -Raw | 
IBS -ExecutePowerShell -name 'test' |
IBP 'test'

$build, $validate, $test | IBD 'Solution' -description 'test'