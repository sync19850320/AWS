<?php
$mysqli = new mysqli("${db_endpoint}", "${db_user}", "${db_pass}", "${db_name}");
if ($mysqli->connect_error) {
    echo "DB接続失敗：" . mysqli->connect_error;
} else {
    echo "DB接続成功!";
}
?>