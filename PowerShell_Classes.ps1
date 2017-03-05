﻿Class Car {

    [string]$Model
    [string]$Type
    [int]$Miles
    
    [Void]Drive([int]$Miles){
        $this.Miles += $Miles
    }
}

$MyCar = [Car]::new()
$MyCar.Model = "Massarati"