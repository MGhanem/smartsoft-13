<html>
<head>
	<title>List</title>
</head>
<body>

	<?php
		echo 'ID: ' . $list->id . '<br />';
        echo 'Name: ' . $list->name . '<br />';
        echo 'Owner ID: ' . $list->owner_id . '<br /><br />';
	?>
	<a href="/index.php/tasklist/viewall/">Back</a>

</body>
</html>