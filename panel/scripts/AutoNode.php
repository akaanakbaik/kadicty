<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Pterodactyl\Models\Location;
use Pterodactyl\Models\Node;
use Illuminate\Support\Str;

$location = Location::firstOrCreate(
    ['short' => 'local'],
    ['long' => 'Local Network']
);

$node = Node::firstOrNew(['name' => 'Local Node']);

if (!$node->exists) {
    $node->fill([
        'location_id' => $location->id,
        'public' => true,
        'fqdn' => 'wings',
        'scheme' => 'http',
        'behind_proxy' => false,
        'memory' => 102400,
        'memory_overallocate' => 0,
        'disk' => 1024000,
        'disk_overallocate' => 0,
        'upload_size' => 100,
        'daemon_sftp' => 2022,
        'daemon_listen' => 8080,
        'maintenance_mode' => false,
        'uuid' => Str::uuid()->toString(),
        'daemon_token_id' => Str::random(16),
        'daemon_token' => Str::random(16),
    ]);
    $node->save();
    echo "Node 'Local Node' created.\n";
} else {
    echo "Node already exists.\n";
}

$config = [
    'debug' => false,
    'uuid' => $node->uuid,
    'token_id' => $node->daemon_token_id,
    'token' => $node->daemon_token,
    'api' => [
        'host' => '0.0.0.0',
        'port' => 8080,
        'ssl' => ['enabled' => false],
        'upload_limit' => 100,
    ],
    'system' => [
        'log_directory' => '/var/log/pterodactyl',
        'data' => '/var/lib/pterodactyl/volumes',
        'archive_directory' => '/var/lib/pterodactyl/backups',
        'user' => ['uid' => 988, 'gid' => 988],
    ],
    'allowed_mounts' => [],
    'allowed_origins' => ['*'],
];

function arrayToYaml($data, $indent = 0) {
    $yaml = '';
    foreach ($data as $key => $value) {
        $spaces = str_repeat('  ', $indent);
        if (is_array($value)) {
            $yaml .= $spaces . $key . ":\n" . arrayToYaml($value, $indent + 1);
        } else {
            $val = is_bool($value) ? ($value ? 'true' : 'false') : (is_string($value) ? "\"$value\"" : $value);
            $yaml .= $spaces . $key . ": " . $val . "\n";
        }
    }
    return $yaml;
}

$yamlContent = arrayToYaml($config);
file_put_contents('/wings_share/config.yml', $yamlContent);
echo "Wings configuration auto-generated at /wings_share/config.yml\n";
