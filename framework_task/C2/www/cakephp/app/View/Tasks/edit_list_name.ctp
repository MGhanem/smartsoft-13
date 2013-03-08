<style>
	div.listedit {
		width: 960px;
		margin: auto;
		padding: 20px;
	}
</style>
<div class="listedit">
	<form name="editlist" action="/cakephp/index.php/checklists/submitNewListName" method="POST">
		<input type="text" name="data[name]" placeholder="list name">
		<input type="hidden" name="data[list_id]" value=<?php echo $list_id?>>
		<input type="submit" value="submit">
	</form>
</div>