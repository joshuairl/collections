/**
 * Iteration functions for Coldfusion Array and Structure Collections
 * 
 * Resources:
 * http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-262.pdf
 * http://documentcloud.github.com/underscore/
 * 
 * 
 * Justin Alpino (twitter: @jalpino)
 * April 27, 2011
 * 
 */
component {

	variables.jCollections = createObject("java","java.util.Collections");
	variables.nill = { index=0, value="" };
	

	/**
	 * Create a new collection by executing the provided callback on each 
	 * element in the provided collection
	 * 
	 * @param data    	a collection of data, can be a struct or an array
	 * 
	 * @param callback	the function to be applied on each item of the provided
	 *                	collection
	 * 
	 * @return       	a collection containing the results of  your callback 
	 *                	for each item (array collections return arrays, struct
	 *                	collections return structs)
	 **/
	 public any function map( required any data, required any callback ){
	 	
	 	if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");

		var v = 0;	
	 	var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		var retData = isArr ? [] : {};
		
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		
		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			retData[k] = arguments.callback( v, k, arguments.data );
		}
		
		return retData;
	}
	
	
	/**
	 * Applies the provided callback on each item in the collection
	 * 
	 * @param data    	a collection of data, can be a struct or an array 
	 * 
	 * @param callback	the function to be applied on each item of the provided
	 *                	collection
	 **/
	 public void function forEach( required any data, required any callback ){
	 	
	 	if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 		
		var v = 0;	
	 	var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		
		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			arguments.callback( v, k, arguments.data );
		}
	}
	
	
	/**
	 * Executes the provided callback for each element in the collection 
	 * (from left to right) passing in the value from the previous execution, 
	 * the value of the current index, the index itself and the original 
	 * provided collection. Use this method to reduce a collection to a single 
	 * value. Structure collections will be iterated by key name in ascending 
	 * order (i.e. mystruct['apple'], mystruct['banana'], mystruct['cucumber'], ...).
	 * 
	 * @param data        	a collection of data, can be a struct or an array  
	 * 
	 * @param callback    	the function builds the accumulated value by being 
	 *                    	applied on each item of the provided collection
	 * 
	 * @param initialvalue	an initial value to use instead of the first item 
	 *                    	of the provided collection (optional)
	 * 
	 * @return            	a value accumulated by each successive iteration
	 * 
	 **/
	public any function reduce( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 	
	 	var v = 0;	
	 	var k = 0;
	 	var i = 1;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		var accumulator = arraylen(arguments) > 2 ? arguments[3] : (isArr ? [] : {});
		var skeys = [];
		
		if( ! dlen )
			return accumulator;
		
		if( ! isArr ){
			skeys =  structKeyArray(arguments.data);
			arraySort(skeys,"textnocase","asc");
		}
		
		if( arraylen(arguments) <= 2 )
			accumulator = arguments.data[( isArr ? i++ : skeys[i++] )];
		
		for( ; i <= dlen; i++ ){
			k = isArr ? i : skeys[i];
			v = arguments.data[k];
			accumulator = callback( accumulator, v, k, arguments.data);
		}
		
		return accumulator;
	}


	/**
	 * Executes the provided callback for each element in the collection 
	 * (from right to left) passing in the value from the previous execution, 
	 * the value of the current index, the index itself and the originaly 
	 * provided collection. Use this method to reduce a collection to a single 
	 * value. Structure collections will be iterated over by key name in 
	 * descending order(i.e. ..., mystruct['cucumber'], mystruct['banana'], mystruct['apple']).
	 * 
	 * @param data       	a collection of data, can be a struct or an array  
	 * 
	 * @param callback    	the function builds the accumulated value by being 
	 *                    	applied on each item of the provided collection
	 * 
	 * @param initialvalue	an initial value to use instead of the first item 
	 *                    	of the provided collection
	 * 
	 * @return            	a value accumulated by each successive iteration. If the collection is empty, an empty string is returned.
	 * 
	 **/
	public any function reduceRight( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 	
	 	var v = 0;	
	 	var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		var accumulator = arraylen(arguments) > 2 ? arguments[3] : (isArr ? [] : {});
		var i = dlen;
		var skeys = [];
				
		if( !dlen )
			return accumulator;
		
		if( ! isArr ){
			skeys = structKeyArray(arguments.data);
			arraySort(skeys,"textnocase","asc");
		}
		
		if( arraylen(arguments) <= 2 )
			accumulator = arguments.data[( isArr ? i-- : skeys[i--] )];
		
		for( ; i > 0; i-- ){
			k = isArr ? i : skeys[i];
			v = arguments.data[k];
			accumulator = callback( accumulator, v, k, arguments.data);
		}
		
		return accumulator;
	}	
	
	
	/**
	 * Returns a filtered collection of items that pass the "test" from the 
	 * provided callback.
	 * 
	 * @param data    	a collection of data, can be a struct or an array
	 * 
	 * @param callback	the function used to "test" items in the provided 
	 *                	collection for inclusion in the returned collection
	 * 
	 * @return        	a filtered collection( array collections return an array, 
	 *                	struct collections return a struct)
	 **/
	public any function filter( required any data, required any callback ){
		return _filter( arguments.data, callback, true );
	}
	
	
	/**
	 * Returns a filtered collection of items that DO NOT pass the "test" from the 
	 * provided callback.
	 * 
	 * @param data    	a collection of data, can be a struct or an array
	 * 
	 * @param callback	the function used to "test" items in the provided 
	 *                	collection for exclusion in the returned collection
	 * 
	 * @return        	a filtered collection( array collections return an array, 
	 *                	struct collections return a struct)
	 **/
	public any function reject( required any data, required any callback ){
		return _filter( arguments.data, callback, false );
	}
	
	
	/**
	 * Returns true if at least one item in the collection passes the "test" 
	 * from the provided callback.
	 * 
	 * @param data    	a collection of data, can be a struct or an array 
	 * 
	 * @param callback	the method used to "test" items in the provided 
	 *                	collection
	 * 
	 * @return        	true if at least one item in the collection passes, 
	 *                	false otherwise
	 **/
	public boolean function some( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 		
		var v = 0;
		var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		if( ! dlen )
			return false;
			
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		
		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			if( callback( v, k, arguments.data ) )
				return true;
		}
		
		return false;
	}
	
		
	/**
	 * Returns true if all of the items in the collection pass the "test" from 
	 * the provided callback.
	 * 
	 * @param data    	a collection of data, can be a struct or an array 
	 * 
	 * @param callback	the method used to "test" items in the provided 
	 *                	collection
	 * 
	 * @return        	true if all items in the collection pass, false 
	 *                	otherwise
	 **/
	public boolean function every( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");

		var v = 0;
		var k = "";
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		if( ! dlen )
			return false;
			
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		
		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			if( ! callback( v, k, arguments.data ) )
				return false;
		}	
			
		return true;
	}
	

	/**
	 * Sorts an array collection using the provided callback for comparison
	 * 
	 * @param data     the collection to be sorted (arrays only)
	 * @param callback the function used to determine sort order. if A < B, return -1; if A == B, return 0; if A > B return 1; 
	 * @return         the sorted collection
	 **/ 
	public array function sort( required array data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 	
	 	if( ! isArray(arguments.data) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Array.");
	 		
		var dlen = arraylen(arguments.data);
		var curr = 0;

		// Selection Sort (easy, minimal swaps, low overhead)
		// TODO: implement a faster sort algorithm
		for( var i=1; i <= dlen; i++){
			curr = i;
			for( var j = i+1; j <= dlen; j++ ){
				if( callback( arguments.data[j], arguments.data[curr] ) < 0 )
					curr = j; // found a new min val
			}
			if( curr != i )
				arraySwap( arguments.data, i, curr );
		}
		
		return arguments.data;		
	}
	
	
	/**
	 * Randomizes the position of items within an array
	 * 
	 * @param data an array of items to randomize
	 * 
	 * @return     a randomized version of the provided array
	 **/
	public array function shuffle( required array data ){
		variables.jCollections.shuffle( arguments.data );
		return arguments.data;
	}
	
	/**
	 * Builds a collection of unique elements based on the passed collection.
	 * @param data	     an array 
	 * @return            a new collection containing only unique items
	 **/
	public any function uniq(){
		var objs = arguments.data;
		var newObj = arrayNew(1);
		
		for(obj in objs) {
			if(NOT ArrayFindNoCase(objs,obj)) {
				arrayAppend(newObj,obj);
			}
		}
		
		return newObj;			
	}
	
	/**
	 * Returns the first item in the collection that passes the "test" 
	 * from the provided callback.
	 * 
	 * @param data    	a collection of data, can be a struct or an array 
	 * 
	 * @param callback	the method used to "test" items in the provided 
	 *                	collection
	 * 
	 * @return        	{ index=<foo>, value=<bar> }; a structure containing 
	 * 					the index and value of the first item in the collection 
	 * 					to pass the test. If no items pass the test, the following
	 * 					default is returned, { index=0, value="" };
	 **/
	public any function detect( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 		
		var v = 0;
		var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		if( ! dlen )
			return variables.nill;
			
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		
		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			if( callback( v, k, arguments.data ) )
				return { index=k, value=v };
		}
		
		return variables.nill;
	}
	
	
	
	/**
	 * Returns the minimum value of the provided collection. The return value
	 * from the callback is used to determine the rank of the items. The return
	 * value should be a data type that can be compared using the less than (<)
	 * operator.   
	 * 
	 * @param data        	a collection of data, can be a struct or an array  
	 * 
	 * @param callback    	the function to generate the value used in determining
	 * 						the minimum value.
	 * 
	 * @return            	{ index=<foo>, value=<bar> }; the "minimum value" and it's index from the provided collection
	 * 
	 **/
	public any function min( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 	
	 	var v = 0;	
	 	var k = 0;
	 	var i = 1;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		if( ! dlen )
			return "";
		
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		k = isArr ? i++ : keys[i++];
		
		var mkey = k;
		var mval = arguments.data[k];
		var mrank = callback( mval, k );
		
		for(; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			rank = callback(v,k);
			
			mval = rank < mrank ? v : mval;
			mkey = rank < mrank ? k : mkey;
			mrank = rank < mrank ? rank : mrank;
			
		}
		
		return { index=mkey, value=mval };
	}
	
	
	/**
	 * Returns the maximum value of the provided collection. The return value
	 * from the callback is used to determine the rank of the items. The return
	 * value should be a data type that can be compared using the greater than (>)
	 * operator. 
	 * 
	 * @param data        	a collection of data, can be a struct or an array  
	 * 
	 * @param callback    	the function to generate the value used in determining
	 * 						the maximum value.
	 * 
	 * @return            	{ index=<foo>, value=<bar> }; the "maximum value" and it's index from the provided collection
	 * 
	 **/
	public any function max( required any data, required any callback ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 	
	 	var v = 0;	
	 	var k = 0;
	 	var i = 1;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		
		if( ! dlen )
			return "";
		
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);
		k = isArr ? i++ : keys[i++];
		
		var mkey = k;
		var mval = arguments.data[k];
		var mrank = callback( mval, k );
		
		for(; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[k];
			rank = callback(v,k);
			
			mval = rank > mrank ? v : mval;
			mkey = rank > mrank ? k : mkey;
			mrank = rank > mrank ? rank : mrank;
		}
		
		return { index=mkey, value=mval };
	}
	
	
	/**
	 * Flattens a nested array collection to a single level. Accepts 
	 * arrays n level deep.
	 * 
	 * @param data  an array collection
	 * 
	 * @return      a flatten version of the provided collection
	 **/
	public array function flatten( required array data ){
		return reduce( data, _flatten, [] );
	}


	/**
	 * Builds a collection in which only the items found in all of the provided
	 * collections are included. All provided collections must be of the same type,
	 * Arrays or Structures. This method will accept N number of collections followed
	 * by an optional comparitor function. 
	 * 
	 * @param data1	     a collection of data, can be a struct or an array 
	 * 
	 * @param data2	     a collection of data, can be a struct or an array
	 * 
	 * @param dataN      (optional) a collection of data, can be a struct or an array
	 * 
	 * @param callback   (optional) the function used to compare two values for equality.
	 *                   If it is not provided, this method will to use the standard
	 *                   == equality operator for comparison
	 * 
	 * @return            a new collection containing only those items that appear 
	 *                    in all of the provided collections.
	 **/
	public any function intersect( ){
		var arg = arguments;
		var alen = arraylen(arg);
		var comparitor = "";
		var c = 1;
		var isArr = false;
		
		if( ! alen )
			throw( type="IllegalArgumentException", message="Missing arguments", detail="At least two collection are required");
		
		if( alen > 2 && isCustomFunction( arg[alen] ) ){
			comparitor = arg[alen];
			arrayDeleteAt( arg, alen-- );
		}else{
			comparitor = _equals;
		}
		
		isArr = every( arg, _isArray );
		if( ! ( isArr || every(arg, _isStruct) ) )
			throw( type="TypeError", message="Invalid collection types", detail="The provided collections must all be of type Array or of type Structure, you can not mix the collection types to intersect.");
		
		var d = arg[ c++ ];
		while( c <= alen ){
			d = _intersect( d, arg[c++], comparitor, isArr );
		}
		
		return d;			
	}


	/**
	 * Used by intersect() to combine common elements in two collections
	 **/
	private any function _intersect( required any a, required any b, required any comparitor, required boolean isArr ){
		/* 
		  TODO: Use something like this if closures and anon functions make into CF
		  for( k in arguments.b ){
		  		v = arguments.b[k];
		  		c = arguments.comparitor;
		  		item = detect( arguments.b, function( val ){ return c( val, v ); });
				if( ! _equals( item, variables.nill ) )
					_append( newcollection, item);
		  }
		  return arguments.a;
		*/
		
		var retData = isArr ? [] : {};
		
		if( ! _size(arguments.a) || ! _size(arguments.b) )
			return retData;
		
		var dlenA = _size( arguments.a );
		var dlenB = _size( arguments.b );
		var keysA = isArr ? arguments.a : structKeyArray(arguments.a);
		var keysB = isArr ? arguments.b : structKeyArray(arguments.b);
		var kA = ""; 
		var kB = ""; 
		var vA = "";
		var vB = "";

		for(var i = 1; i <= dlenA; i++ ){
			kA = arguments.isArr ? i : keysA[i];
			vA = arguments.a[ kA ];
			
			for(var j = 1; j <= dlenB; j++ ){
				kB = arguments.isArr ? j : keysB[j];
				vB = arguments.b[ kB ]	;
				if( arguments.comparitor(vA,vB) ){
					if( isArr )
						arrayAppend( retData, vB );
					else
						retData[ kB ] = vB;
				}
			}	
		}
		
		return retData;
	}


	/**
	 * Used by flatten() to equal out the heirarchy
	 **/
	private any function _flatten( any accumulator, any value ){
		if ( isArray( arguments.value ) ) {
			return _merge(arguments.accumulator, flatten(arguments.value) );
		}
		arrayAppend( arguments.accumulator, arguments.value);
      	return arguments.accumulator;
	}
	
		
	/**
	 * Used by filter() and reject(), the 'truth' argument should be true and false respectively
	 **/
	private any function _filter( required any data, required any callback, required boolean truth ){
		
		if( ! isCustomFunction(arguments.callback) )
	 		throw( type="TypeError", message="Invalid callback", detail="The provided callback is not a valid function." );
	 		
	 	if( !( isArray(arguments.data) || isStruct(arguments.data) ) )	
	 		throw( type="TypeError", message="Invalid collection type", detail="The provided collection is not a valid Structure or Array.");
	 	
		var v = 0;
		var k = 0;
		var dlen = _size(arguments.data);
		var isArr = isArray(arguments.data);
		var retData = isArr ? [] : {};
		
		if( ! dlen )
			return retData;
			
		var keys =  isArr ? arguments.data : structKeyArray(arguments.data);

		for( var i = 1; i <= dlen; i++ ){
			k = isArr ? i : keys[i];
			v = arguments.data[ k ];
			if( callback( v, k, arguments.data ) == arguments.truth ){
				if( isArr )
					arrayAppend(retData, v);
				else
					retData[k] = v;
			}
		}
			
		return retData;
		
	}
	
	
	/**
	 * Concatinates two arrays
	 **/
	private array function _merge( required array arr1, required array arr2 ){
		// Railo has arrayMerge, but this a lot faster
		for( var i=1; i <= arraylen(arguments.arr2); i++){
			arrayAppend( arguments.arr1, arguments.arr2[i] );
		}
		return arguments.arr1;
	}
		
	
	/**
	 * Returns the size of the supplied collection
	 **/
	private numeric function _size( required any data ){
		if( isArray(arguments.data) )
			return arrayLen(arguments.data);
			
		if( isStruct(arguments.data) )
			return structCount(arguments.data);
	}


	/**
	 * Wrapper for isArray to be used by Collections.cfc methods
	 **/
	private boolean function _isArray( required any data ){
		return isArray( arguments.data );
	}
	
	
	/**
	 * Wrapper for isStruct to be used by Collections.cfc methods
	 **/
	private boolean function _isStruct( required any data ){
		return isStruct( arguments.data );
	}

	
	/**
	 * Returns true if a and b are equal using the standard equality operator ==
	 * 
	 * TODO: Make this better, mimicking mxunit's assertEquals();
	 **/
	private boolean function _equals( required any a, required any b ){
		return arguments.a == arguments.b;
	}
				
}