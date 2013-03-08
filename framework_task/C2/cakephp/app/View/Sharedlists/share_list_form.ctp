<style>
	div.listedit {
		width: 960px;
		margin: auto;
		padding: 20px;
	}
</style>
<div class="listedit">
	<form name="shareWith" action="/cakephp/index.php/sharedlists/shareList" method="POST">
		<input type="text" name="data[user_name]" placeholder="name of user">
		<input type="hidden" name="data[list_id]" value=<?php echo $listID?>>
		<input type="submit" value="share">
	</form>
</div>