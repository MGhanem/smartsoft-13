<style>
	div.listedit {
		width: 960px;
		margin: auto;
		padding: 20px;
	}
</style>
<div class="listedit">
	<form name="editlist" action="/cakephp/index.php/checklists/submitNewListName" method="POST">
		<input type="text" name="listName" placeholder="list name">
		<input type="hidden" value=<?php echo $listId?>>
		<input type="submit" value="submit">
	</form>
</div>