//Derived from the C implementation of KnapSack 0/1 using Memoization 
//and Linked Lists provided by Andrej Koselj 

extern "C" void FindInvoicesC(int,int,int[],int,int[]);

extern "C" void FindInvoicesC(int thisProcAddress, int targetSum, int thisArray[], int nRows, int invoiceArray[])
    {
     int i;
     int j;
     int nextSum;
	 
     int* thisArraySums;
  	 int* thisArrayResults;

  	 thisArraySums = thisArray;
  	 thisArrayResults = thisArray+(targetSum+1);

     for(i=0;i<nRows;i++) //INVOICE ARRAY
     {
         j=0;
         while (1)
         {
             nextSum = invoiceArray[i] + j;

             if (nextSum > targetSum || thisArraySums[nextSum] != -1)
             {
                 j = thisArraySums[j];
             }
             else
             {
                 thisArraySums[nextSum] = thisArraySums[j];
                 thisArraySums[j] = nextSum;
                 thisArrayResults[nextSum] = j;
                 j = thisArraySums[nextSum];
             }

             if (j<=0)
             {
                 break;
             }
         }

         if (thisArraySums[targetSum] != -1)
         {
             break;
         }
     }
     return;
}
