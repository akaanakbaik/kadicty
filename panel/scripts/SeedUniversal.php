<?php
require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Pterodactyl\Models\Nest;
use Pterodactyl\Models\Egg;

$nest = Nest::firstOrCreate(
    ['author' => 'support@pterodactyl.io', 'name' => 'Universal Runner'],
    ['description' => 'A universal nest for running any container image directly.']
);

$eggData = [
    'nest_id' => $nest->id,
    'author' => 'support@pterodactyl.io',
    'name' => 'Generic Docker',
    'description' => 'Run any Docker image with custom startup commands. Supports Node, Python, Java, Go, etc.',
    'docker_image' => 'ghcr.io/pterodactyl/yolks:debian',
    'startup' => '{{STARTUP_CMD}}',
    'config' => [
        'files' => [],
        'startup' => ['done' => 'Container started'],
        'stop' => '^C',
        'logs' => [],
        'extends' => null,
    ],
    'scripts' => [
        'installation' => [
            'script' => '#!/bin/bash
            apt-get update -y
            apt-get install -y git curl wget
            if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi
            if [ -f "package.json" ]; then npm install; fi
            if [ -f "go.mod" ]; then go mod download; fi
            echo "Installation Completed"',
            'container' => 'ghcr.io/pterodactyl/installers:debian',
            'entrypoint' => 'bash',
        ],
    ],
];

$egg = Egg::firstOrNew(['nest_id' => $nest->id, 'name' => 'Generic Docker']);
$egg->fill($eggData);
$egg->forceFill([
    'environment' => [
        'STARTUP_CMD' => 'bash', 
        'SECOND_CMD' => 'echo "Started"' 
    ]
]);
$egg->save();

echo "Universal Nest & Egg seeded successfully.\n";
