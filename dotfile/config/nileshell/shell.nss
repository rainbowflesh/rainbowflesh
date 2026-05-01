settings
{
	priority=1
	exclude.where = !process.is_explorer
	showdelay = 200
	// Options to allow modification of system items
	modify.remove.duplicate=1
	tip.enabled=true
}

theme
{
    font
    {
        size = 28
    }
}

import 'imports/theme.nss'
import 'imports/images.nss'
import 'imports/modify.nss'
import 'imports/all.autorename.nss'
import 'imports/all.clipboard.save.nss'
import 'imports/all.drive.file.nss'
import 'imports/all.sendto.nss'
import 'imports/bar.address.nss'
import 'imports/bar.scroll.nss'
import 'imports/bar.title.nss'
import 'imports/edit.nss'
import 'imports/sys.compress.extract.nss'
import 'imports/taskbar.nss'

menu(mode="multiple" title="Pin/Unpin" image=icon.pin){}
menu(mode="multiple" title=title.more_options image=icon.more_options){}

modify(find="Open" image=[\ue8e5, 'Segoe Fluent Icons'])
modify(find="Open in new tab" image=[\ue737, 'Segoe Fluent Icons'])
modify(find="Open in new window" image=[\ue8a7, 'Segoe Fluent Icons'])

modify(find="Open with" position=indexof("Open", 1) image=[\ue7ac, 'Segoe Fluent Icons'])
modify(find="Pick Link Source" position=indexof("Copy", 1) image=[\ue71b, 'Segoe Fluent Icons'])
modify(find="WinRar" position=indexof("Compress*", 1))

modify(find="*NVIDIA*" vis=hidden)
modify(find="*Defender*" vis=hidden)

modify(find="WinRAR" parent="Compress and Extract")

modify(find="Compress and Extract" parent="More options")
modify(find="Pick Link Source" parent="More options")
modify(find="Copy list" parent="More options")
modify(find="Copy path" parent="More options")
modify(find="Pin*" parent="More options")
modify(find="*Icon*" parent="More options")

modify(find="Copy path" position=indexof("Copy", 1))