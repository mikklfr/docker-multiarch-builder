for template in templates/*
do
    ARCHS=("amd64" "arm64" "armhf" "i386")
    
    for arch in "${ARCHS[@]}"
    do  
	sed "s/{ARCH}/$arch/g" "$template" > .dockerfile.tmp
	imageName=`basename $template`:"$arch"
	docker rmi "mikkl/$imageName"
	docker build -t mikkl/"$imageName" -f .dockerfile.tmp . 
	docker push mikkl/"$imageName"
    done
done