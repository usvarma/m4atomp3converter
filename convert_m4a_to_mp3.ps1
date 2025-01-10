
param([string]$inputpath, [string]$outputpath="convertedfiles")

$isValidInputPath = Test-Path -path $inputpath
$isValidOutputPath = Test-Path -path $outputpath
$current_directory = pwd
$default_output_folder = "convertedfiles"

if(!$isValidOutputPath)
{
	$outputpath = "{0}{1}" -f $current_directory,$default_output_folder
	mkdir $outputpath
}


if ( $isValidInputPath )
{
	$folders = @(Get-ChildItem -path $inputpath -Name)
	
	foreach($folder in $folders)
	{
		$folder_full_path = "{0}\{1}" -f $inputpath,$folder
		$m4afiles = @(Get-ChildItem -path $folder_full_path -Filter *.m4a -Name)
		
		if ( $m4afiles.count -gt 0 )
		{
			$output_folder = "{0}\{1}" -f $outputpath,$folder
			mkdir $output_folder
			
			$target_file_extension = ".mp3"
			
			foreach ($file in $m4afiles)
			{
			  $input_file_fullpath = "{0}\{1}" -f $folder_full_path,$file
			  $substringsize = $file.Length - 4
			  
			  $outputfile = "{0}{1}" -f $file.Substring(0, $substringsize),$target_file_extension
			  $output_file_path = "{0}\{1}" -f  $output_folder,$outputfile
			  
			  ffmpeg -i $input_file_fullpath -c:a libmp3lame -q:a 0 $output_file_path
			}
		}
	}
}
