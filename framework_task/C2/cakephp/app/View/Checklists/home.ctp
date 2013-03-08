	<div class="body">
		<section>
			<div class="lists">
				    <?php foreach ($checklists as $list): ?>
        			<?php if ($list['Checklist']['user_id'] === $SessionID) { ?>
        			<?php $listID = $list['Checklist']['list_id'] ?>
    				<a><?php echo $this->Html->link('X', array('action' => 'deleteList', 'id' => $list['Checklist']['list_id'], $listID)) ?></a>
       				<?php echo $this->Html->link($list['Checklist']['name'], array('controller' => 'tasks', 'action' => 'listTasks', $list['Checklist']['list_id'], $list['Checklist']['name'])); ?>
        			<?php } ?>
        			
        			<br>
    				<?php endforeach; ?>
    				<?php unset($list); ?>
			</div>
			<div class="shared">
				<?php echo $this->Html->link('+ New List', array('controller' => 'checklists', 'action' => 'newList')) ?>
				<h2>Shared Lists</h2>
				<div class="SharedLists">
					//Shared Lists
				</div>
			</div>
		</section>
	</div>