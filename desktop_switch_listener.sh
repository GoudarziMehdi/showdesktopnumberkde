#!/bin/bash
# Monitor KDE desktop changes using dbus-monitor

# echo "Starting desktop monitoring..."  # Debugging output

# Function to display overlay using osd_cat
show_overlay() {
  CURRENT_DESKTOP=$1
  echo "Desktop $CURRENT_DESKTOP" | osd_cat \
    -p middle -A center -d 1 \
    -c "#FFFFFF" \
    -s 1 -S "#333333" \
    -f "-*-helvetica-bold-r-normal--48-*-*-*-*-*-*-*"
}

# Monitor desktop change events from org.kde.KWin.VirtualDesktopManager
dbus-monitor "interface='org.kde.KWin.VirtualDesktopManager',member='currentChanged'" | while read -r line; do
  # Debugging: Output each line received from dbus-monitor
  # echo "Received line: $line"

  # Check for the event indicating a desktop change
  if [[ "$line" == *"currentChanged"* ]]; then
    # Get the current desktop number (1-based index)
    CURRENT_DESKTOP=$(qdbus org.kde.KWin /KWin org.kde.KWin.currentDesktop)

    # Debugging: Output the current desktop number
    # echo "Current Desktop: $CURRENT_DESKTOP"

    # Call the function to display overlay
    show_overlay $CURRENT_DESKTOP
  fi
done

# 