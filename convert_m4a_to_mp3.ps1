param([string]$inputpath, [string]$outputpath = "convertedfiles")


# This function takes input path where audio files are present
# Converts the audio files to target file format and writes to output path
#Assumptions: Both input and output path must be folders(directories)
function ConvertToMp3 {

	param(
		[string] $inputpath,
		[string] $outputpath
	)
	
	$m4afiles = @(Get-ChildItem -path $inputpath -Filter *.m4a -Name)
		
	if ( $m4afiles.count -gt 0 ) {
			
		$isOutputFolderExists = Test-Path -LiteralPath $outputpath
		if (!$isOutputFolderExists) {
			mkdir $outputpath
		}	
			
		foreach ($file in $m4afiles) {
			$input_file_fullpath = Join-Path -Path $inputpath -ChildPath $file
			$substringsize = $file.Length - 4
			  
			$outputfile = "{0}{1}" -f $file.Substring(0, $substringsize), $target_file_extension
			$output_file_path = Join-Path -Path $outputpath -ChildPath $outputfile
			  
			ffmpeg -i $input_file_fullpath -c:a libmp3lame -q:a 0 $output_file_path
		}
	}
}

$isValidInputPath = Test-Path -LiteralPath $inputpath
$isValidOutputPath = Test-Path -LiteralPath $outputpath
$current_directory = Get-Location
$default_output_folder = "convertedfiles"
$target_file_extension = ".mp3"


if ( $isValidInputPath ) {
	
	#Check if user has entered a value for output folder
	#If user has not entered any value, set the default output folder as a subfolder of current working folder
	if (!$isValidOutputPath) {
		$outputpath = Join-Path -Path $current_directory -ChildPath $default_output_folder
		$isOutputDirExists = Test-Path -path $outputpath
		if (!$isOutputDirExists) {
			mkdir $outputpath
		}
	}

	#If the input path has subfolders, call the function to convert the files recursively
	#by getting the subfolders

	$subfolders = @(Get-ChildItem -path $inputpath -Recurse -Directory -Name)

	if ( $subfolders.count -gt 0 ) {
		foreach ($subfolders in $subfolders) {
			$input_path = Join-Path -Path $inputpath -ChildPath $subfolders
			$output_path = Join-Path -Path $outputpath -ChildPath $subfolders
	
			ConvertToMp3 -inputpath $input_path -outputpath $output_path
		}
	}
	else {
		#Input path doesn't have any sub-folders. So set the output directory name same as input directory name
		$input_directory = Split-Path -Path $inputpath -Leaf
		$output_path = Join-Path -Path $outputpath -ChildPath $input_directory
		
		ConvertToMp3 -inputpath $inputpath -outputpath $output_path
	}

}
else {
	Write-Output "Please check your input path. It seems to be invalid."
	Write-Output "Path entered: ${inputpath}"
}


