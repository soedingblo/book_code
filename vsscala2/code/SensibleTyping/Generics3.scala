/***
 * Excerpted from "Pragmatic Scala",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/vsscala2 for more book information.
***/
import java.util._

var list1 = new ArrayList[Int]                          
var list2 = new ArrayList[Any]

var ref1 : Int = 1
var ref2 : Any = null
            
ref2 = ref1 //OK

list2 = list1 // Compilation Error
