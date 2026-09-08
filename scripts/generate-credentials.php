<?php

echo "APP_KEY=base64:" . base64_encode(random_bytes(32)) . PHP_EOL;
echo "REVERB_APP_ID=groser-" . random_int(100000, 999999) . PHP_EOL;
echo "REVERB_APP_KEY=" . bin2hex(random_bytes(16)) . PHP_EOL;
echo "REVERB_APP_SECRET=" . bin2hex(random_bytes(24)) . PHP_EOL;
