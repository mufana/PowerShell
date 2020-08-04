$json = @"
{
    "FirstNames":  [
                       "Fabian",
                       "Tony",
                       "Alberto",
                       "Jan",
                       "Vincenzo",
                       "Alejandro",
                       "Tom",
                       "Johan",
                       "Cadel",
                       "Frederico",
                       "Marco",
                       "Raymond",
                       "Igor",
                       "Andre",
                       "David",
                       "Zdnek",
                       "Michele",
                       "Boris",
                       "Novak",
                       "Rafael",
                       "Roger",
                       "Steffi",
                       "John",
                       "Andy",
                       "Bjorn",
                       "Shaquile",
                       "Michael",
                       "Kobe",
                       "Lebron",
                       "Erving",
                       "Larry"
                    ],
    "Modifiers":  [
                      "'Spartacus'",
                      "'Panzerwagen'",
                      "'El Pistolero'",
                      "'The Yoyo'",
                      "'The Shark from Messina'",
                      "'EL Imbatido'",
                      "'The Seagull'",
                      "'Cuddles'",
                      "'The Eagle of Toledo'",
                      "'The Pirate'",
                      "'Pou Pou'",
                      "'Fuji'",
                      "'The Gorilla'",
                      "'Styby'",
                      "'The Dandy'",
                      "'The Eagle'",
                      "'Baron van Slam'",
                      "'Djoker Nole'",
                      "'El Matador'",
                      "'Fed Express'",
                      "'Fraulein Forehand'",
                      "'SuperBrat'",
                      "'Muzza'",
                      "'Ice Borg'",
                      "'Diesel'",
                      "'His Airness'",
                      "'Black Mamba'",
                      "'King'",
                      "'Magic'",
                      "'Larry Legend'"


                  ],
    "LastNames":  [
                      "Cancellara",
                      "Martin",
                      "Contador",
                      "Ulrich",
                      "Nibali",
                      "Valverde",
                      "Musseuw",
                      "Evens",
                      "Bahamontes",
                      "Pantani",
                      "Poulidor",
                      "Anton",
                      "Greipel",
                      "Stybar",
                      "Miller",
                      "Scarponi",
                      "Becker",
                      "Djokovich",
                      "Nadal",
                      "Federer",
                      "Graf",
                      "Mcenroe",
                      "Murray",
                      "Borg",
                      "'O Neal",
                      "Jordan",
                      "Byrant",
                      "James",
                      "Johnson",
                      "Bird"
                     ]
}
"@

function Get-SportsLegend {
    [CmdletBinding()]
    param()

    $jsonData = $json | ConvertFrom-Json

    $sportsLegend = "{0} {1} {2}" -f (Get-Random $jsonData.FirstNames),(Get-Random $jsonData.Modifiers),(Get-Random $jsonData.LastNames)

    Write-Output $sportsLegend
}
