/*

JAPriorityQueue.h


Copyright (C) 2007 Jens Ayton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

#import <Foundation/Foundation.h>


@interface JAPriorityQueue: NSObject <NSCopying>
{
	SEL						_comparator;
	id						*_heap;
	unsigned				_count,
							_capacity;
}

// Note: -init is equivalent to -initWithComparator:@selector(compare:)
+ (id) queueWithComparator:(SEL)comparator;
- (id) initWithComparator:(SEL)comparator;

- (void) addObject:(id)object;			// May throw NSInvalidArgumentException or NSMallocException.
- (void) removeObject:(id)object;		// Uses comparator (looking for NSOrderedEqual) to find object. Note: relatively expensive.
- (void) removeExactObject:(id)object;	// Uses pointer comparison to find object. Note: still relatively expensive.

- (unsigned) count;

- (id) nextObject;
- (id) peekAtNextObject;				// Returns next object without removing it.
- (void) removeNextObject;

- (void) addObjects:(id)collection;		// collection must respond to -nextObject, or implement -objectEnumerator to return something that implements -nextObject -- such as an NSEnumerator.

- (NSArray *) sortedObjects;			// Returns the objects in -nextObject order and empties the heap. To get the objects without emptying the heap, copy the priority queue first.
- (NSEnumerator *) objectEnumerator;	// Enumerator which pulls objects off the heap until it's empty. Note however that the queue itself behaves like an enumerator, as -nextObject has similar semantics (except that the enumerator's -nextObject can never start returning objects after it returns nil).

@end
