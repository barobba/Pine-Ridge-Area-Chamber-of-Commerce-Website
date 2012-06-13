<?php
if ($_GET['randomId'] != "dwynChq7Qwgol6IMlFvMGDAuD3HNjIgobbARQwlLyyxUtK5Y6zqvGRNerMOIsI4N") {
    echo "Access Denied";
    exit();
}

// display the HTML code:
echo stripslashes($_POST['wproPreviewHTML']);

?>  
