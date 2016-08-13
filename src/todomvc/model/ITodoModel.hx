package todomvc.model;

import hex.mdvc.model.IOutput;

/**
 * @author Francis Bourre
 */
interface ITodoModel 
{
	var output( default, never ) : IOutput<ITodoConnection>;
	function addTodo( item : TodoItem ) : Void;
	function removeTodo( item : TodoItem ) : Void;
}