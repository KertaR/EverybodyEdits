package utilities
{
   public class AsyncTasks
   {
      
      private var tasks:int;
      
      private var oc:Function;
      
      private var cur:int = 0;
      
      private var finish:Boolean = false;
      
      public function AsyncTasks(param1:int, param2:Function)
      {
         super();
         if(isNaN(param1) || param1 <= 0)
         {
            throw new Error("Provided invalid amount");
         }
         this.tasks = param1;
         this.oc = param2;
      }
      
      public function get current() : int
      {
         return this.cur;
      }
      
      public function get total() : int
      {
         return this.tasks;
      }
      
      public function get completed() : Boolean
      {
         return this.finish;
      }
      
      private function update() : void
      {
         if(this.cur == this.tasks && !this.finish)
         {
            this.finish = true;
            this.oc();
         }
         else
         {
            if(this.finish)
            {
               throw new Error("Callback has been already called");
            }
            if(this.cur > this.tasks)
            {
               throw new Error("Got more tasks than expected");
            }
         }
      }
      
      public function addTask() : void
      {
         if(this.finish)
         {
            throw new Error("Can\'t add any more tasks, callback has been already called");
         }
         ++this.tasks;
      }
      
      public function next() : void
      {
         ++this.cur;
         this.update();
      }
   }
}

