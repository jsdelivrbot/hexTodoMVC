package todomvc.model;

import common.ITodoConnection;
import common.TodoItem;
import hex.di.IInjectorContainer;
import hex.log.ILogger;
import hex.mdvc.model.IOutput;

/**
 * ...
 * @author Francis Bourre
 */
class TodoModel implements ITodoModel implements IInjectorContainer
{
	@Output
	public var output( default, never ) : IOutput<ITodoConnection>;
	
	@Inject
	public var logger : ILogger;
	
	var _items : Array<TodoItem>;
	
	public function new() 
	{
		this._items = [];
	}
	
	public function getAllTodos() : Array<TodoItem>
	{
		#if debug
		logger.debug( ['TodoModel.getAllTodos'] );
		#end
		
		return this._items.copy();
	}
	
	public function getActiveTodos() : Array<TodoItem>
	{
		#if debug
		logger.debug( ['TodoModel.getActiveTodos'] );
		#end
		
		var items = [];
		for ( item in this._items )
		{
			if ( !item.completed ) 
			{
				items.push( item );
			}
		}
		
		return items;
	}
	
	public function getCompletedTodos() : Array<TodoItem>
	{
		#if debug
		logger.debug( ['TodoModel.getCompletedTodos'] );
		#end
		
		var items = [];
		for ( item in this._items )
		{
			if ( item.completed ) 
			{
				items.push( item );
			}
		}
		
		return items;
	}
	
	public function addTodo( item : TodoItem ) : Void
	{
		#if debug
		logger.debug( ['TodoModel.addTodo:', item] );
		#end
		
		this.output.clearNewTodo();
		this._items.push( item );
		this.output.showEntries( this._items );
		this._updateCount();
	}
	
	public function removeTodo( id : String ) : Void
	{
		#if debug
		logger.debug( ['TodoModel.removeTodo:', id] );
		#end
		
		for ( index in 0...this._items.length )
		{
			if ( this._items[ index ].id == id )
			{
				this._items.splice( index, 1 );
				this.output.removeItem( id );
				this._updateCount();
				break;
			}
		}
	}
	
	public function editTodo( id : String ) : Void
	{
		var todo = this._getTodo( id );
		this.output.editItem( todo.id, todo.title );
	}
	
	public function removeCompleted() : Void
	{
		#if debug
		logger.debug( ['TodoModel.removeCompleted'] );
		#end
		
		var l = this._items.length;
		var item = null;
		while ( l-- > 0 )
		{
			item = this._items[ l ];
			
			if ( item.completed )
			{
				this._items.splice( l, 1 );
				this.output.removeItem( item.id );
			}
		}
		
		if ( item != null )
		{
			this._updateCount();
		}
	}

	public function updateTodo( id : String, isCompleted : Bool ) : Void
	{
		#if debug
		logger.debug( ['TodoModel.updateTodo:', id, isCompleted] );
		#end
		
		for ( item in this._items )
		{
			if ( item.id == id ) 
			{
				item.completed = isCompleted;
				this.output.elementComplete( id, isCompleted );
				this._updateCount();
				break;
			}
		}
	}
	
	public function editTodoTitle( id : String, title : String ) : Void
	{
		#if debug
		logger.debug( ['TodoModel.editTodoTitle:', id, title] );
		#end
		
		var todo = this._getTodo( id );
		todo.title = title;
		this._updateCount();
		this.output.editItemDone( id, title );
	}
	
	public function cancelEdition( id : String ) : Void
	{
		#if debug
		logger.debug( ['TodoModel.cancelEdition:', id] );
		#end
		
		var todo = this._getTodo( id );
		this._updateCount();
		this.output.editItemDone( id, todo.title );
	}
	
	//private
	function _getTodo( id : String ) : TodoItem
	{
		for ( item in this._items )
		{
			if ( item.id == id ) 
			{
				return item;
			}
		}
		
		return null;
	}
	
	function _updateCount() : Void
	{
		#if debug
		logger.debug( ['TodoModel._updateCount'] );
		#end
		
		var completedItemCount 	= 0;
		var activeItemCount 	= 0;
		
		for ( item in this._items )
		{
			if ( item.completed ) 
			{
				completedItemCount++;
			} 
			else 
			{
				activeItemCount++;
			}
		}
		
		var itemCount 	= completedItemCount + activeItemCount;
		var todos 		= this.getAllTodos();
		
		this.output.updateItemCount( activeItemCount );
		this.output.clearCompletedButton( completedItemCount, completedItemCount > 0 );
		this.output.toggleAll( completedItemCount == itemCount );
		this.output.setFooterVisibility( itemCount > 0 );
	}
}