<div class="tasks">
    <style>
    	div.content {
    		width: 960px;
    		margin: auto;
    	}
    	div.left, div.right {
    		float: left;
    	}
    	div.left {
    		width: 480px;
    	}
    	div.task h4 {
    		font-size: 20px;
    		display: inline-block;
    	}
    	div.right {
    		width: 480px;
    	}
    	div.listhdr h2 {
    		display: inline-block;
    	}
            div.listedit {
        width: 960px;
        margin: auto;
        padding: 20px;
    }
    </style>
    <div class="listedit">
        <form name="editlist" action="/cakephp/index.php/tasks/edittasksave" method="POST">
            <input type="text" name="data[content]" placeholder="content">
            <input type="hidden" name="data[task_id]" value=<?php echo $task_id?>>
            <input type="hidden" name="data[list_id]" value=<?php echo $list_id?>>
            <input type="hidden" name="data[list_name]" value=<?php echo $list_name?>>
            <input type="submit" value="submit">
        </form>
    </div>

</div>