package com.nickkadutskyi.jb.palette

import com.intellij.ide.util.PropertiesComponent
import com.intellij.notification.NotificationGroupManager
import com.intellij.notification.NotificationType
import com.intellij.openapi.actionSystem.ActionUpdateThread
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.fileChooser.FileChooserFactory
import com.intellij.openapi.fileChooser.FileSaverDescriptor
import com.intellij.openapi.progress.ProgressIndicator
import com.intellij.openapi.progress.Task
import com.intellij.openapi.project.DumbAwareAction
import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.LocalFileSystem
import com.intellij.openapi.vfs.VfsUtil
import java.io.File

class ExportPaletteAction : DumbAwareAction() {
    override fun getActionUpdateThread(): ActionUpdateThread = ActionUpdateThread.BGT

    override fun actionPerformed(event: AnActionEvent) {
        val project = event.project
        val target = chooseTarget(project) ?: return
        object : Task.Backgroundable(project, "Exporting Color Scheme Palette", false) {
            override fun run(indicator: ProgressIndicator) {
                try {
                    val result = PaletteExporter.exportTo(target.toPath())
                    VfsUtil.markDirtyAndRefresh(true, false, false, target)
                    notify(project, "${result.message} → ${result.path.fileName}", NotificationType.INFORMATION)
                } catch (error: Throwable) {
                    notify(
                        project,
                        "Palette export failed: ${error.message ?: error.javaClass.simpleName}",
                        NotificationType.ERROR,
                    )
                }
            }
        }.queue()
    }

    private fun chooseTarget(project: Project?): File? {
        val properties = PropertiesComponent.getInstance()
        val lastPath = properties.getValue(LAST_PATH_KEY)
        val descriptor = FileSaverDescriptor(
            "Export Active Color Scheme Palette",
            "Choose the standalone palette JSON file",
            "json",
        )
        val dialog = FileChooserFactory.getInstance().createSaveFileDialog(descriptor, project)
        val baseDir = lastPath?.let { LocalFileSystem.getInstance().findFileByPath(File(it).parent ?: it) }
        val selected = dialog.save(baseDir, lastPath?.let { File(it).name } ?: DEFAULT_FILE_NAME) ?: return null
        val file = selected.file
        properties.setValue(LAST_PATH_KEY, file.absolutePath)
        return file
    }

    private fun notify(project: Project?, message: String, type: NotificationType) {
        NotificationGroupManager.getInstance()
            .getNotificationGroup(NOTIFICATION_GROUP)
            .createNotification(message, type)
            .notify(project)
    }

    companion object {
        private const val LAST_PATH_KEY = "jb.palette.exporter.lastPath"
        private const val DEFAULT_FILE_NAME = "intellij-palette.json"
        private const val NOTIFICATION_GROUP = "JB Palette Exporter"
    }
}
