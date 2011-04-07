package com.wezside.components.survey.command {
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;

	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class CustomDataCommand extends Command {
		
		override public function execute( event : Event ):void {
			super.execute( event );
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "" ));
		}
	}
}