import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, User } from '@prisma/client';
import { PrismaService } from '../../database/prisma.service';
import { CurrentUserPayload } from '../../types';
import { SyncUserProfileDto } from './dto/sync-user-profile.dto';
import { UpdateUserProfileDto } from './dto/update-user-profile.dto';

export type UserProfileResponse = {
  id: string;
  supabaseId: string | null;
  externalAuthId: string | null;
  email: string;
  fullName: string | null;
  username: string | null;
  phone: string | null;
  bio: string | null;
  dateOfBirth: string | null;
  gender: string | null;
  city: string | null;
  occupationStatus: string | null;
  personalityTypes: string[];
  socialComfort: string | null;
  selectedInterestIds: string[];
  hobbiesNarrative: string | null;
  authProvider: string | null;
  profileImageUrl: string | null;
  meetupsAttended: number;
  meetupsHosted: number;
  badges: string[];
  favoriteCommunities: string[];
  isOnboarded: boolean;
  createdAt: string;
  updatedAt: string;
};

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async syncFromApp(dto: SyncUserProfileDto): Promise<UserProfileResponse> {
    const email = this.resolveEmail(dto.email, dto.externalAuthId, dto.authProvider);
    const { firstName, lastName } = this.splitFullName(dto.fullName);

    const data: Prisma.UserCreateInput = {
      externalAuthId: dto.externalAuthId,
      supabaseId: dto.supabaseId ?? null,
      email,
      authProvider: dto.authProvider ?? null,
      fullName: dto.fullName ?? null,
      firstName,
      lastName,
      username: dto.username ?? null,
      phone: dto.phone ?? null,
      bio: dto.bio ?? null,
      dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : null,
      gender: dto.gender ?? null,
      location: dto.city ?? null,
      occupationStatus: dto.occupationStatus ?? null,
      personalityTypes: dto.personalityTypes ?? [],
      socialComfort: dto.socialComfort ?? null,
      selectedInterestIds: dto.selectedInterestIds ?? [],
      hobbiesNarrative: dto.hobbiesNarrative ?? null,
      profileImageUrl: dto.profileImageUrl ?? null,
      isOnboarded: dto.isOnboarded ?? false,
      lastActivityAt: new Date(),
    };

    const user = await this.prisma.user.upsert({
      where: { externalAuthId: dto.externalAuthId },
      create: data,
      update: {
        ...this.omitUndefined({
          supabaseId: dto.supabaseId,
          email,
          authProvider: dto.authProvider,
          fullName: dto.fullName,
          firstName,
          lastName,
          username: dto.username,
          phone: dto.phone,
          bio: dto.bio,
          dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : undefined,
          gender: dto.gender,
          location: dto.city,
          occupationStatus: dto.occupationStatus,
          personalityTypes: dto.personalityTypes,
          socialComfort: dto.socialComfort,
          selectedInterestIds: dto.selectedInterestIds,
          hobbiesNarrative: dto.hobbiesNarrative,
          profileImageUrl: dto.profileImageUrl,
          isOnboarded: dto.isOnboarded,
        }),
        lastActivityAt: new Date(),
      },
    });

    return this.toResponse(user);
  }

  async getBySupabaseId(supabaseId: string): Promise<UserProfileResponse> {
    const user = await this.prisma.user.findUnique({ where: { supabaseId } });
    if (!user) {
      throw new NotFoundException('User profile not found');
    }
    return this.toResponse(user);
  }

  async getByExternalAuthId(externalAuthId: string): Promise<UserProfileResponse> {
    const user = await this.prisma.user.findUnique({ where: { externalAuthId } });
    if (!user) {
      throw new NotFoundException('User profile not found');
    }
    return this.toResponse(user);
  }

  async updateForSupabaseUser(
    current: CurrentUserPayload,
    dto: UpdateUserProfileDto,
  ): Promise<UserProfileResponse> {
    let user = await this.prisma.user.findUnique({
      where: { supabaseId: current.supabaseId },
    });

    if (!user) {
      user = await this.prisma.user.create({
        data: {
          supabaseId: current.supabaseId,
          email: current.email,
          lastActivityAt: new Date(),
        },
      });
    }

    return this.applyUpdate(user.id, dto);
  }

  async ensureSupabaseUser(current: CurrentUserPayload): Promise<UserProfileResponse> {
    const user = await this.prisma.user.upsert({
      where: { supabaseId: current.supabaseId },
      create: {
        supabaseId: current.supabaseId,
        email: current.email,
        lastLoginAt: new Date(),
        lastActivityAt: new Date(),
      },
      update: {
        email: current.email,
        lastLoginAt: new Date(),
        lastActivityAt: new Date(),
      },
    });
    return this.toResponse(user);
  }

  private async applyUpdate(
    userId: string,
    dto: UpdateUserProfileDto,
  ): Promise<UserProfileResponse> {
    const { firstName, lastName } = dto.fullName
      ? this.splitFullName(dto.fullName)
      : { firstName: undefined, lastName: undefined };

    try {
      const user = await this.prisma.user.update({
        where: { id: userId },
        data: this.omitUndefined({
          fullName: dto.fullName,
          firstName,
          lastName,
          username: dto.username,
          phone: dto.phone,
          bio: dto.bio,
          dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : undefined,
          gender: dto.gender,
          location: dto.city,
          occupationStatus: dto.occupationStatus,
          personalityTypes: dto.personalityTypes,
          socialComfort: dto.socialComfort,
          selectedInterestIds: dto.selectedInterestIds,
          hobbiesNarrative: dto.hobbiesNarrative,
          profileImageUrl: dto.profileImageUrl,
          isOnboarded: dto.isOnboarded,
          lastActivityAt: new Date(),
        }),
      });
      return this.toResponse(user);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('Username or email already taken');
      }
      throw error;
    }
  }

  private resolveEmail(
    email: string | undefined,
    externalAuthId: string,
    authProvider?: string,
  ): string {
    if (email?.trim()) {
      return email.trim().toLowerCase();
    }
    if (authProvider === 'guest') {
      return `guest-${externalAuthId}@likeminds.app`;
    }
    return `user-${externalAuthId}@likeminds.app`;
  }

  private splitFullName(fullName?: string): {
    firstName: string | null;
    lastName: string | null;
  } {
    if (!fullName?.trim()) {
      return { firstName: null, lastName: null };
    }
    const parts = fullName.trim().split(/\s+/);
    if (parts.length === 1) {
      return { firstName: parts[0], lastName: null };
    }
    return {
      firstName: parts[0],
      lastName: parts.slice(1).join(' '),
    };
  }

  private omitUndefined<T extends Record<string, unknown>>(obj: T): Partial<T> {
    return Object.fromEntries(
      Object.entries(obj).filter(([, value]) => value !== undefined),
    ) as Partial<T>;
  }

  private toResponse(user: User): UserProfileResponse {
    return {
      id: user.id,
      supabaseId: user.supabaseId,
      externalAuthId: user.externalAuthId,
      email: user.email,
      fullName: user.fullName,
      username: user.username,
      phone: user.phone,
      bio: user.bio,
      dateOfBirth: user.dateOfBirth
        ? user.dateOfBirth.toISOString().slice(0, 10)
        : null,
      gender: user.gender,
      city: user.location,
      occupationStatus: user.occupationStatus,
      personalityTypes: user.personalityTypes,
      socialComfort: user.socialComfort,
      selectedInterestIds: user.selectedInterestIds,
      hobbiesNarrative: user.hobbiesNarrative,
      authProvider: user.authProvider,
      profileImageUrl: user.profileImageUrl,
      meetupsAttended: user.meetupsAttended,
      meetupsHosted: user.meetupsHosted,
      badges: user.badges,
      favoriteCommunities: user.favoriteCommunities,
      isOnboarded: user.isOnboarded,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    };
  }
}
