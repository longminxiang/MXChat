#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY="$(cd "${1%/*}" && pwd)"
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "../../MXChatView/Views/ChatCell/MXChatListCell.xib"
  install_resource "../../MXChatView/Views/InputView/MXInputToobar.xib"
  install_resource "../../MXChatView/Resources/MXChat.bundle"
  install_resource "../../MXChatView/Resources/Face/emoji_angry@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_anguished@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_astonished@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_blush@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_clap@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_cold_sweat@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_confounded@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_confused@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_cry@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_disappointed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_disappointed_relieved@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_dizzy_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_expressionless@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_fearful@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_flushed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_frowning@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grimacing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grin@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grinning@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_heart_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_hushed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_innocent@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_joy@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_closed_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_heart@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_smiling_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_laughing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_mask@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_neutral_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_no_mouth@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_open_mouth@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_pensive@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_persevere@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_point_left@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_point_right@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_rage@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_relaxed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_relieved@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_satisfied@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_scream@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sleeping@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sleepy@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smile@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smiley@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smirk@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sob@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue_closed_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue_winking_eye@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sunglasses@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sweat@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sweat_smile@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_thumbsdown@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_thumbsup@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_tired_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_triumph@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_unamused@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_weary@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_wink@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_worried@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_yum@2x.png"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "../../MXChatView/Views/ChatCell/MXChatListCell.xib"
  install_resource "../../MXChatView/Views/InputView/MXInputToobar.xib"
  install_resource "../../MXChatView/Resources/MXChat.bundle"
  install_resource "../../MXChatView/Resources/Face/emoji_angry@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_anguished@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_astonished@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_blush@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_clap@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_cold_sweat@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_confounded@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_confused@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_cry@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_disappointed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_disappointed_relieved@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_dizzy_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_expressionless@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_fearful@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_flushed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_frowning@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grimacing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grin@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_grinning@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_heart_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_hushed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_innocent@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_joy@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_closed_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_heart@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_kissing_smiling_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_laughing@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_mask@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_neutral_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_no_mouth@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_open_mouth@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_pensive@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_persevere@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_point_left@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_point_right@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_rage@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_relaxed@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_relieved@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_satisfied@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_scream@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sleeping@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sleepy@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smile@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smiley@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_smirk@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sob@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue_closed_eyes@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_stuck_out_tongue_winking_eye@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sunglasses@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sweat@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_sweat_smile@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_thumbsdown@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_thumbsup@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_tired_face@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_triumph@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_unamused@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_weary@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_wink@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_worried@2x.png"
  install_resource "../../MXChatView/Resources/Face/emoji_yum@2x.png"
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
