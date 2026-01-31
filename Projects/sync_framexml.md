## init classic_era
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic_era --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source vanilla"
cd "wow-ui-source vanilla"
git remote add ketho https://github.com/Ketho/wow-ui-source-vanilla
git pull origin classic_era
git push ketho classic_era:classic_era
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

## init midnight
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b beta --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source midnight"
cd "wow-ui-source midnight"
git remote add ketho https://github.com/Ketho/wow-ui-source-midnight
git pull origin beta
git push ketho beta:beta
```

## init bcc
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic_anniversary --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source bcc"
cd "wow-ui-source bcc"
git remote add ketho https://github.com/Ketho/wow-ui-source-bcc
git pull origin classic_anniversary
git push ketho classic_anniversary:classic_anniversary
```

## update
```sh
cd "D:\Repo\wow\wow-framexml\wow-ui-source midnight"
git pull origin beta
git push ketho beta

cd "D:\Repo\wow\wow-framexml\wow-ui-source mists"
git pull origin classic
git push ketho classic

cd "D:\Repo\wow\wow-framexml\wow-ui-source bcc"
git pull origin classic_anniversary
git push ketho classic_anniversary

cd "D:\Repo\wow\wow-framexml\wow-ui-source vanilla"
git pull origin classic_era
git push ketho classic_era:classic_era

```
