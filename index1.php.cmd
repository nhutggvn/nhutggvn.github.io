<?php
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

// Đường dẫn tới các tệp
$ipaFile = 'path_to_your_app.ipa';
$p12File = 'path_to_your_certificate.p12';
$mobileProvisionFile = 'path_to_your_mobileprovision.mobileprovision';
$password = 'your_password';

// Upload IPA
$ipa = new CURLFile(realpath($ipaFile));
$ipaUploadURL = 'https://api.starfiles.co/upload/upload_file';
$ipaOutput = uploadFile($ipaUploadURL, $ipa);

// Upload P12
$p12 = new CURLFile(realpath($p12File));
$p12UploadURL = 'https://api.starfiles.co/upload/upload_file';
$p12Output = uploadFile($p12UploadURL, $p12);

// Upload Mobileprovision
$mobileprovision = new CURLFile(realpath($mobileProvisionFile));
$mobileProvisionUploadURL = 'https://api.starfiles.co/upload/upload_file';
$mobileProvisionOutput = uploadFile($mobileProvisionUploadURL, $mobileprovision);

// Sign
$signURL = 'https://sign.starfiles.co';
$signedIPA = signIPA($signURL, $ipaOutput, $p12Output, $mobileProvisionOutput, $password);

function uploadFile($uploadURL, $file) {
    $curl = curl_init($uploadURL);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: multipart/form-data'));
    curl_setopt($curl, CURLOPT_POSTFIELDS, array('upload' => $file));
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($curl);
    $output_decoded = json_decode($output, true);
    if(!isset($output_decoded['file'])) {
        die('Upload failed: ' . $output);
    }
    curl_close($curl);
    return $output_decoded['file'];
}

function signIPA($signURL, $ipa, $p12, $mobileprovision, $password) {
    $signURL .= "?ipa=$ipa&p12=$p12&mobileprovision=$mobileprovision&password=$password";
    return file_get_contents($signURL);
}
?>
