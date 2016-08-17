package todomvc.control;

import common.Filter;
import common.TodoItem;
import hex.control.ICompletable;
import hex.mdvc.driver.IForwarder;
import hex.mdvc.log.IsLoggable;

/**
 * @author Francis Bourre
 */
interface ITodoController extends IForwarder extends IsLoggable
{
	function setFilter( filter : Filter ) : Void;
	
	function showAll() : ICompletable<Array<TodoItem>>;

	function showActive() : ICompletable<Array<TodoItem>>;

	function showCompleted() : ICompletable<Array<TodoItem>>;

	function addItem( title : String ) : Void;

	function editItem( id : String ) : Void;

	function editItemSave( id : String, title : String ) : Void;

	function editItemCancel( id : String ) : Void;

	function removeItem( id : String ) : Void;

	function removeCompletedItems() : Void;

	function toggleComplete( id : String, isCompleted : Bool ) : Void;

	function toggleAll( isCompleted : Bool ) : Void;
}