USER="mikkl"

for template in templates/*
do
    ARCHS=("amd64" "arm64" "armhf" "i386" "armv6l")
    IMAGES=("multiarch\/ubuntu-core:amd64-xenial" "multiarch\/ubuntu-core:arm64-xenial" "multiarch\/ubuntu-core:armhf-xenial" "multiarch\/ubuntu-core:i386-xenial" "resin\/rpi-raspbian:jessie")
    for i in "${!ARCHS[@]}"
    do
      arch=${ARCHS[$i]}
      image=${IMAGES[$i]}

      outputImageName="$USER"/`basename $template`:"$arch"
      sed "s/{IMAGE}/$image/g" "$template" > .dockerfile.tmp

      echo "-- Creating $outputImageName --"
      read -n 1 -p "Remove old docker image ? y/n " yn
      echo ""
      case $yn in
       [Yy]* ) docker rmi $outputImageName;;
      esac

      read -n 1 -p "Build docker image ? y/n " yn
      echo ""
      case $yn in
       [Yy]* ) docker build -t $outputImageName -f .dockerfile.tmp .;;
      esac

      read -n 1 -p "Push docker image ? y/n " yn
      echo ""
      case $yn in
       [Yy]* ) docker push $outputImageName;;
      esac

    done
done
