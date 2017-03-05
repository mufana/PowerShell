Class Car {

    [string]$Model
    [string]$Type
    [int]$Miles
    
    [Void]Drive([int]$Miles){
        $this.Miles += $Miles
    }
}

$MyCar = [Car]::new()
$MyCar.Model = "Massarati"$MyCar.Type = "Quatroporte"$Mycar.Miles = "1000"$MyCar.Drive(200)