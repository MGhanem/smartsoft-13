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
    </style>
    <div class="content">
        <div class="left">
            <div class="listhdr"><h2><?php echo $TaskName?>&nbsp;&nbsp;&nbsp;</h2><?php echo $this->Html->link('Edit', array('action' => 'editListName', $ListID)) ?></div>
            <a href="#">+ New Task</a>
            <div class="sharedwith">
                <h3>Shared with: <a href="#">+</a></h3>
                <div class="userclass">
                    //shared
                </div>
            </div>
        </div>
        <div class="right">

            <div class="task">
                    <?php foreach ($tasks as $task): ?>
                    <?php $taskID = $task['Task']['task_id'] ?>
    <?php if ($task['Task']['list_id'] === $ListID) { ?>
    <div><h4><?php echo $task['Task']['content'] ?></h4>
    <?php if ($task['Task']['checked'] === '1') { ?>
            <a><?php echo $this->Html->link('Mark as undone', array('action' => 'uncheck', $taskID)) ?></a>
    <?php } else { ?>
            <a><?php echo $this->Html->link('Mark as done', array('action' => 'check', $taskID)) ?></a>
        </div></div>
    <a><?php echo $this->Html->link('Delete', array('action' => 'deleteTask', 'id' => $task['Task']['task_id'], $taskID)) ?></a>
            </div>
    <?php } ?>
    <?php } ?>
    <br>
    <?php endforeach; ?>
    <?php unset($list); ?>
            </div>
        </div>
    </div>
</div>