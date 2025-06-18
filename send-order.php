<?php
require 'vendor/autoload.php';
use CourierDZ\CourierDZ;
use CourierDZ\Enum\ShippingProvider;

header('Content-Type: application/json');

$input = json_decode(file_get_contents("php://input"), true);

if (!$input || !isset($input['provider'], $input['apiKey'], $input['order'])) {
  echo json_encode(["error" => "Missing provider name, API key, or order data"]);
  exit;
}

try {
    // Convert the provider name string to the appropriate ShippingProvider enum case
    $providerEnum = ShippingProvider::from($input['provider']);
    
    $provider = CourierDZ::provider($providerEnum, [
        "key" => $input['apiKey']
    ]);

    $response = $provider->createOrder($input['order']);

    echo json_encode($response);
} catch (Exception $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
