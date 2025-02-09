param([string]$inputPath, [string]$outputPath = "convertedfiles")


# This function takes input path where audio files are present
# Converts the audio files to target file format and writes to output path
#Assumptions: Both input and output path must be folders(directories)
function ConvertToMp3 {

	param(
		[string] $inputPath,
		[string] $outputPath
	)
	
	$audiofiles = @(Get-ChildItem -path $inputPath -Filter *.m4a -Name)
		
	if ( $audiofiles.count -gt 0 ) {
			
		$isOutputFolderExists = Test-Path -LiteralPath $outputPath
		if (!$isOutputFolderExists) {
			mkdir $outputPath
		}	
			
		foreach ($file in $audiofiles) {
			$inputFileFullPath = Join-Path -Path $inputPath -ChildPath $file
			$substringSize = $file.Length - 4
			  
			$outputFile = "{0}{1}" -f $file.Substring(0, $substringSize), $outputFormat
			$outputFilePath = Join-Path -Path $outputPath -ChildPath $outputFile
			  
			ffmpeg -i $inputFileFullPath -c:a libmp3lame -q:a 0 $outputFilePath
		}
	}
}

$isValidInputPath = Test-Path -LiteralPath $inputPath
$isValidOutputPath = Test-Path -LiteralPath $outputPath
$currentDirectory = Get-Location
$defaultOutputFolder = "convertedfiles"
$outputFormat = ".mp3"


if ( $isValidInputPath ) {
	
	#Check if user has entered a value for output folder
	#If user has not entered any value, set the default output folder as a subfolder of current working folder
	if (!$isValidOutputPath) {
		$outputPath = Join-Path -Path $currentDirectory -ChildPath $defaultOutputFolder
		$isOutputDirExists = Test-Path -path $outputPath
		if (!$isOutputDirExists) {
			mkdir $outputPath
		}
	}

	#If the input path has subfolders, call the function to convert the files recursively
	#by getting the subfolders

	$subFolders = @(Get-ChildItem -path $inputPath -Recurse -Directory -Name)

	if ( $subFolders.count -gt 0 ) {
		foreach ($subfolder in $subFolders) {
			$finalInputPath = Join-Path -Path $inputPath -ChildPath $subfolder
			$finalOutputPath = Join-Path -Path $outputPath -ChildPath $subfolder
	
			ConvertToMp3 -inputPath $finalInputPath -outputPath $finalOutputPath
		}
	}
	else {
		#Input path doesn't have any sub-folders. So set the output directory name same as input directory name
		$finalInputPath = Split-Path -Path $inputPath -Leaf
		$finalOutputPath = Join-Path -Path $outputPath -ChildPath $finalInputPath
		
		ConvertToMp3 -inputPath $inputPath -outputPath $finalOutputPath
	}

}
else {
	Write-Output "Please check your input path. It seems to be invalid."
	Write-Output "Path entered: ${inputPath}"
}


