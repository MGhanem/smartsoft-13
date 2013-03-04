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
	
	<form action="/index.php/tasklist/delete/<?php echo $list->id;?>">­
    <input type="Submit" value="Delete List">
    </form>
    
    <form action="/index.php/tasklist/viewall/">­
    <input type="Submit" value="Back">
    </form>

	
</body>
</html>