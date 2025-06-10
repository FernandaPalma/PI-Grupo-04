<?php

session_start();

session_destroy();

header("Location: /PI-Grupo-04/Site/index.html");

exit();
