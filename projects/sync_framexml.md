
## init standard ptr
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b ptr2 --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source standard-ptr"
cd "wow-ui-source standard-ptr"
git remote add ketho https://github.com/Ketho/wow-ui-source-standard-ptr
git pull origin ptr2
git push ketho ptr2:ptr2
```

## init mists
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source mists"
cd "wow-ui-source mists"
git remote add ketho https://github.com/Ketho/wow-ui-source-mists
git pull origin classic
git push ketho classic:classic
```

## init tbc
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic_anniversary --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source bcc"
cd "wow-ui-source tbc"
git remote add ketho https://github.com/Ketho/wow-ui-source-tbc
git pull origin classic_anniversary
git push ketho classic_anniversary:classic_anniversary
```


## init classic_era
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic_era --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source vanilla"
cd "wow-ui-source vanilla"
git remote add ketho https://github.com/Ketho/wow-ui-source-vanilla
git pull origin classic_era
git push ketho classic_era:classic_era
```

## init forever
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b forever --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source forever"
cd "wow-ui-source forever"
git remote add ketho https://github.com/Ketho/wow-ui-source-forever
git pull origin forever
git push ketho forever:forever
```

## update
- windows
```sh
cd "D:\Repo\wow\wow-framexml\wow-ui-source standard-ptr"
git pull origin ptr2
git push ketho ptr2

cd "D:\Repo\wow\wow-framexml\wow-ui-source mists"
git pull origin classic
git push ketho classic

cd "D:\Repo\wow\wow-framexml\wow-ui-source tbc"
git pull origin classic_anniversary
git push ketho classic_anniversary

cd "D:\Repo\wow\wow-framexml\wow-ui-source vanilla"
git pull origin classic_era
git push ketho classic_era:classic_era

cd "D:\Repo\wow\wow-framexml\wow-ui-source forever"
git pull origin forever
git push ketho forever:forever
```

- WSL
```sh
cd "/mnt/d/Repo/wow/wow-framexml/wow-ui-source midnight-ptr"
git pull origin ptr
git push ketho ptr

cd "/mnt/d/Repo/wow/wow-framexml/wow-ui-source mists"
git pull origin classic
git push ketho classic

cd "/mnt/d/Repo/wow/wow-framexml/wow-ui-source bcc"
git pull origin classic_anniversary
git push ketho classic_anniversary

cd "/mnt/d/Repo/wow/wow-framexml/wow-ui-source vanilla"
git pull origin classic_era
git push ketho classic_era:classic_era
```
