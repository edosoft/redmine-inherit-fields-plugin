# Subtasks Inherited Fields plugin

Subtasks Inherited Fields is a plugin that allows to choose which fields are inherited by default from parent issue when you create a subtask, in order to create subtasks faster. It also allows to select the default subtask tracker.

## Install

```
cd $REDMINE_FOLDER/plugins
git clone https://github.com/edosoft/redmine-inherit-fields-plugin.git redmine_subtasks_inherited_fields
```

Then restart Redmine to apply the changes.
 
## Usage 

* As an admin user, go to Administration -> Plugins -> Redmine Subtasks Inherited Fields plugin config link
* Choose which fields you want to inherit by default and the default subtask tracker
* Apply changes and go back to issues view

-![alt text](http://i.imgur.com/72vkngQ.png)

* Go to an issue in which you want to create a subtask

-![alt text](http://i.imgur.com/6KPIyNq.png)

* Click on add subtask and observe how the configured fields are inherited

-![alt text](http://i.imgur.com/UwdP78K.png)

## Uninstall

```
rm -rf $REDMINE_FOLDER/plugins/redmine_subtasks_inherited_fields 
```
Then restart Redmine to apply the changes.

## Testing plugin

To run tests for this plugin enter the following command:

```
rake redmine:plugins:test 
```

Additional RSpec tests can also be run by entering the following command:

```
rspec plugins/redmine_subtasks_inherited_fields/spec
```

## Contact

If you have any doubt please raise an Github Issue. Comments are Welcome!
