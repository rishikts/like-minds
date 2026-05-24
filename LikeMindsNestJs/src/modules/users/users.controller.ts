import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SyncApiKeyGuard } from '../../common/guards/sync-api-key.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { CurrentUserPayload } from '../../types';
import { SyncUserProfileDto } from './dto/sync-user-profile.dto';
import { UpdateUserProfileDto } from './dto/update-user-profile.dto';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  /**
   * iOS app sync (Apple/Google/Guest) — uses X-LikeMinds-Sync-Key header.
   * PUT /api/v1/users/profile/sync
   */
  @Put('profile/sync')
  @UseGuards(SyncApiKeyGuard)
  async syncProfile(@Body() dto: SyncUserProfileDto) {
    const data = await this.usersService.syncFromApp(dto);
    return { message: 'Profile synced', data };
  }

  /**
   * Fetch profile by external auth id (same sync key).
   * GET /api/v1/users/profile/:externalAuthId
   */
  @Get('profile/:externalAuthId')
  @UseGuards(SyncApiKeyGuard)
  async getProfileByExternalId(@Param('externalAuthId') externalAuthId: string) {
    const data = await this.usersService.getByExternalAuthId(externalAuthId);
    return { message: 'Profile loaded', data };
  }

  /** Supabase JWT — current user profile */
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getMe(@CurrentUser() user: CurrentUserPayload) {
    const data = await this.usersService.ensureSupabaseUser(user);
    return { message: 'Profile loaded', data };
  }

  /** Supabase JWT — update current user */
  @Patch('me')
  @UseGuards(JwtAuthGuard)
  async patchMe(
    @CurrentUser() user: CurrentUserPayload,
    @Body() dto: UpdateUserProfileDto,
  ) {
    const data = await this.usersService.updateForSupabaseUser(user, dto);
    return { message: 'Profile updated', data };
  }

  /** Supabase JWT — upsert after sign-in */
  @Post('me/ensure')
  @UseGuards(JwtAuthGuard)
  async ensureMe(@CurrentUser() user: CurrentUserPayload) {
    const data = await this.usersService.ensureSupabaseUser(user);
    return { message: 'User ensured', data };
  }
}
