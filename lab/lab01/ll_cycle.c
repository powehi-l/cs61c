#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
	node *tortoise, *hare;
	tortoise = hare = head;
	do{
		if(hare == NULL)
			return 0;
		hare = hare->next;
		if(hare == NULL)
			return 0;
		hare = hare->next;
		tortoise = tortoise->next;
	}while(tortoise != hare);

    /* your code here */
   	return 1;
}
