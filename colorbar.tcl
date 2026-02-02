## NAME: color_scale_bar
## 
## SYNOPSIS:
##   color_scale_bar draws a color bar on the screen to show all of the
##   current colors (colorid 17~1040). It also shows labels beside the 
##   color bar to show the range of the mapped values.
##
## VERSION: 2.0
##    Uses VMD version:  VMD Version 1.7 or greater
##    Ease of use: 2. need to understand some Tcl and a bit about how VMD
##                 works
## 
## PROCEDURES:
##      color_scale bar
## 
## DESCRIPTION:
##      To draw a color scale bar with length=1.5, width=0.25, the range of
##      mapped values is 0~128, and you want 8 labels.
##      color_scale_bar 1.5  0.25  0  128 8
## 
## COMMENTS: The size of the bar also depends on the zoom scale.
## 
## AUTHOR:
##      Wuwei Liang (gtg088c@prism.gatech.edu)
## 
##      New version 2 built on Wuwei Liang's code, by Dan Wright 
##                  <dtwright@uiuc.edu>
##      Modified by Yuyang Zhang for VERSION 3 with ChatGPT
## 
## CHANGES:
##      * draws the bar in a new molecule
##      * has defaults for all parameters so nothing has to be entered manually
##      * functions moved into a seperate namespace
##      * has a delete function (just deletes the seperate mol for now)
##      * fixed position so it remains visible when the scene is rotated
##
## USAGE:
## Run the following in the console window:
## 
## 1) 'source colorbartest.tcl'
## 2) 'namespace import ::ColorBar::*'
## 3) run 'color_scale_bar' to create the bar with default parameters;
##    run 'delete_color_scale_bar' to remove it from the display

# This function draws a color bar to show the color scale
# length = the length of the color bar
# width = the width of the color bar
# min = the minimum value to be mapped
# max = the maximum mapped value
# label_num = the number of labels to be displayed for compatibility (older VMD may not support molinfo get minmax)

namespace eval ::ColorBar:: {
    variable bar_mol
    namespace export color_scale_bar delete_color_scale_bar
}

proc ::ColorBar::color_scale_bar {{length 0.8} {width 0.08} {auto_scale 1} \
                                  {fixed 1} {min 0} {max 10} {label_num 5} \
                                  {title "ESP(kcal/mol)"} \
                                  {offset_x 0.9} {offset_y 0.0} {offset_z 0.0} \
                                  {title_offset 0.10} \
                                  {anchor "screen"} {margin_x 0.7} {margin_y 0.0} {margin_z 0.0}} {
    variable bar_mol
    display update off

    set old_top [molinfo top]
    set bar_mol [mol new]
    mol top $bar_mol

    if {$fixed == 1} {
        mol fix $bar_mol
    }

    if {$auto_scale == 1} {
        set min 999
        set max -99
        foreach m [molinfo list] {
            if {$m != $bar_mol} {
                set minmax [split [mol scaleminmax $m 0]]
                if {$min > [lindex $minmax 0]} { set min [lindex $minmax 0] }
                if {$max < [lindex $minmax 1]} { set max [lindex $minmax 1] }
            }
        }
    }
    #--------------------------Set scale and layer creation finished------------------------------------
    #Setting position

    if {$anchor eq "bbox"} {
        set anchor_id $old_top
        foreach m [molinfo list] {
            if {$m == $bar_mol} { continue }
            set nm [string tolower [molinfo $m get name]]
            if {[string match "*vtx*" $nm]} {
                set anchor_id $m
                break
            }
        }
        set sel [atomselect $anchor_id "all"]
        set mm [measure minmax $sel]
        $sel delete
        set xmin [lindex [lindex $mm 0] 0]
        set ymin [lindex [lindex $mm 0] 1]
        set zmin [lindex [lindex $mm 0] 2]
        set xmax [lindex [lindex $mm 1] 0]
        set ymax [lindex [lindex $mm 1] 1]
        set zmax [lindex [lindex $mm 1] 2]
        set use_x [expr {0.5*($xmin + $xmax) + $margin_x}]
        set use_y [expr {0.5*($ymin + $ymax) + $margin_y}]
        set use_z [expr {0.5*($zmin + $zmax) + $margin_z}]
        puts "ColorBar anchor=bbox (anchor_id=$anchor_id, name=[molinfo $anchor_id get name])"
    } elseif {$anchor eq "screen"} {
    puts "ColorBar anchor=screen (fixed screen position coordinates)"

    set view_data  [molinfo $old_top get {center_matrix rotate_matrix scale_matrix global_matrix}]
    set center_mat [lindex $view_data 0]
    set rotate_mat [lindex $view_data 1]
    set scale_mat  [lindex $view_data 2]
    set global_mat [lindex $view_data 3]

    set use_x $offset_x
    set use_y $offset_y
    set use_z $offset_z
    
    } else {
        set center [molinfo $old_top get center]
        set center [split [regsub -all {[{}]} $center ""]]
        set use_x [expr {[lindex $center 0] + $offset_x}]
        set use_y [expr {[lindex $center 1] + $offset_y}]
        set use_z [expr {[lindex $center 2] + $offset_z}]
        puts "ColorBar anchor=center (old_top=$old_top, name=[molinfo $old_top get name])"
    }

    # --- Draw the color scale bar as small line segments for each color index ---
    set start_y [expr {$use_y - 0.5*$length}]
    set step    [expr {$length / 1024.0}]
    puts "ColorBar position: use_x=$use_x, start_y=$start_y, use_z=$use_z"

    # --- Draw the color scale bar as small line segments for each color index ---
    for {set colorid 17} {$colorid <= 1040} {incr colorid 1} {
        draw color $colorid
        set cur_y [expr {$start_y + ($colorid - 17) * $step}]
        draw line "$use_x $cur_y $use_z" "[expr {$use_x + $width}] $cur_y $use_z"
    }

    # --- Draw the numeric labels beside the bar ---
    set coord_x [expr {$use_x + 1.2*$width}]
    set step_size [expr {$length / $label_num}]
    set value_step [expr {($max - $min) / double($label_num)}]
    for {set i 0} {$i <= $label_num} {incr i} {
        draw color black
        set coord_y [expr {$start_y + $i * $step_size}]
        set cur_val [expr {$min + $i * $value_step}]
        draw text "$coord_x $coord_y $use_z" [format "%6.2f" $cur_val]
    }

    # --- Draw the title (scale label) above the bar, if provided ---
    if {$title ne ""} {
        set title_x [expr {$use_x + 0.5*$width}]
        set title_y [expr {$start_y + $length + $title_offset}]
        draw color black
        draw text "$title_x $title_y $use_z" $title
    }

    # Restore original top molecule and rename the bar molecule for clarity
    mol top $old_top
    mol rename $bar_mol "ColorBar"
    display update on
}

proc ::ColorBar::delete_color_scale_bar { } {
    variable bar_mol
    if {[info exists bar_mol] && [lsearch -exact [molinfo list] $bar_mol] != -1} {
        mol delete $bar_mol
    }
}
