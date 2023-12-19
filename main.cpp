#include <iostream>
#include <fstream>
using namespace std;
ifstream f("input.txt");
int a[20][20], b[20][20];
int dx[] = {0, 1, 0, -1, 1, 1, -1, -1};
int dy[] = {1, 0, -1, 0, 1, -1, 1, -1};

int main()
{
    int m, n, p, x, y, k;
    f>>n>>m>>p;
    while(p--)
    {
        f>>x>>y; ++x; ++y;
        a[x][y]=b[x][y]=1;
    }

    // for(int i=0; i<=n+1; ++i)
    // {
    //     for(int j=0; j<=m+1; ++j)
    //         cout<<a[i][j]<<" ";
    //     cout<<'\n';
    // }    

    f>>k;
    while(k--)
    {
        for(int i=1; i<=n; ++i)
            for(int j=1; j<=m; ++j)
            {
                int cnt=0;
                for(int k=0; k<8; ++k)
                {
                    x=i+dx[k]; y=j+dy[k];
                    if(a[x][y]) cnt++;
                }

                if(cnt<2 || cnt>3) b[i][j] = 0;
                if(cnt == 3) b[i][j]=1;
            }

        for(int i=1; i<=n; ++i)
            for(int j=1; j<=m; ++j)
                a[i][j]=b[i][j]; 
    }

    for(int i=1; i<=n; ++i)
    {
        for(int j=1; j<=m; ++j)
            cout<<a[i][j]<<" ";
        cout<<'\n';
    }    
}